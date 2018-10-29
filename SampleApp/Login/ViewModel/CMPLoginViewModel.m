//
//  CMPLoginViewModel.m
//  SampleApp
//
//  Created by Dominik Kowalski on 05/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPLoginViewModel.h"
#import "AppDelegate.h"

@implementation CMPLoginViewModel

- (instancetype)init {
    self = [super init];

    if (self) {
        self.loginBundle = [[CMPLoginBundle alloc] initWithApiSpaceID:@"aa67c980-7215-4f30-b81e-245e31aa8fef" profileID:@"iOStest" issuer:@"https://api.comapi.com/defaultauth" audience:@"https://api.comapi.com" secret:@"bbf888f67ddf3ce11cc13039efbd8996c8bb1622"];
    }
    
    return self;
}

- (void)saveLocally {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.loginBundle];
    [NSUserDefaults.standardUserDefaults setObject:data forKey:@"loginInfo"];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)configureWithCompletion:(void (^)(NSError * _Nullable))completion {
    if (![self.loginBundle isValid]) {
        completion(nil);
        return;
    }
    
    CMPComapiConfig *config = [[CMPComapiConfig alloc] initWithApiSpaceID:self.loginBundle.apiSpaceID authenticationDelegate:self logLevel:CMPLogLevelVerbose];
    NSError *initError = nil;
    self.client = [CMPComapi initialiseWithConfig:config error:&initError];
    if (initError) {
        [NSException raise:@"failed client init" format:@""];
    }
    AppDelegate *appDel = (AppDelegate *)UIApplication.sharedApplication.delegate;
    appDel.configurator.client = self.client;
    if (!initError) {
        __weak typeof(self) weakSelf = self;
        [self.client.services.session startSessionWithCompletion:^{
            [weakSelf saveLocally];
            completion(nil);
        } failure:^(NSError * _Nullable err) {
            completion(err);
        }];
    } else {
        completion(initError);
    }
}

- (void)clientWith:(CMPComapiClient *)client didReceiveAuthenticationChallenge:(CMPAuthenticationChallenge *)challenge completion:(void (^)(NSString * _Nullable))continueWithToken {
    NSString *token = [CMPAuthenticationManager generateTokenForNonce:challenge.nonce profileID:self.loginBundle.profileID issuer:self.loginBundle.issuer audience:self.loginBundle.audience secret:self.loginBundle.secret];
    
    continueWithToken(token);
}

@end
