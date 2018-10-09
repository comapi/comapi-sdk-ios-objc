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
        self.loginBundle = [[CMPLoginBundle alloc] init];
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
    self.client = [CMPComapi initialiseWithConfig:config];
    AppDelegate *appDel = (AppDelegate *)UIApplication.sharedApplication.delegate;
    appDel.configurator.client = self.client;
    if (self.client) {
        __weak typeof(self) weakSelf = self;
        [self.client.services.session startSessionWithCompletion:^{
            [weakSelf saveLocally];
            completion(nil);
        } failure:^(NSError * _Nullable err) {
            completion(err);
        }];
    } else {
        [NSException raise:@"failed client init" format:@""];
    }
}

- (void)clientWith:(CMPComapiClient *)client didReceiveAuthenticationChallenge:(CMPAuthenticationChallenge *)challenge completion:(void (^)(NSString * _Nullable))continueWithToken {
    NSString *token = [CMPAuthenticationManager generateTokenForNonce:challenge.nonce profileID:self.loginBundle.profileID issuer:self.loginBundle.issuer audience:self.loginBundle.audience secret:self.loginBundle.secret];
    
    continueWithToken(token);
}

@end
