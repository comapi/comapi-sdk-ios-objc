//
//  CMPLoginViewModel.m
//  SampleApp
//
//  Created by Dominik Kowalski on 05/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPLoginViewModel.h"
#import "AppDelegate.h"

//@"aa67c980-7215-4f30-b81e-245e31aa8fef"
//@"iOStest"
//@"https://api.comapi.com/defaultauth"
//@"https://api.comapi.com"
//@"bbf888f67ddf3ce11cc13039efbd8996c8bb1622"
@implementation CMPLoginViewModel

- (instancetype)init {
    self = [super init];

    if (self) {
        self.loginBundle = [[CMPLoginBundle alloc] initWithApiSpaceID:@"be466e4b-1340-41fc-826e-20445ab658f1" profileID:@"sub" issuer:@"local" audience:@"local" secret:@"secret"];
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
    if (!self.client) {
        [NSException raise:@"failed client init" format:@""];
    }
    AppDelegate *appDel = (AppDelegate *)UIApplication.sharedApplication.delegate;
    appDel.configurator.client = self.client;
    __weak typeof(self) weakSelf = self;
    [self.client.services.session startSessionWithCompletion:^{
        [weakSelf saveLocally];
        completion(nil);
    } failure:^(NSError * _Nullable err) {
        completion(err);
    }];
}

- (void)getProfileWithCompletion:(void (^)(CMPProfile * _Nullable, NSError * _Nullable))completion {
    if (!self.client) {
        completion(nil, nil);
    }

    [self.client.services.profile getProfileWithProfileID:self.client.profileID completion:^(CMPResult<CMPProfile *> * result) {
        if (result.error) {
            completion(nil, result.error);
        } else {
            completion(result.object, nil);
        }
    }];
}

- (void)client:(CMPComapiClient *)client didReceiveAuthenticationChallenge:(CMPAuthenticationChallenge *)challenge completion:(void (^)(NSString * _Nullable))continueWithToken {
    NSString *token = [CMPAuthenticationManager generateTokenForNonce:challenge.nonce profileID:self.loginBundle.profileID issuer:self.loginBundle.issuer audience:self.loginBundle.audience secret:self.loginBundle.secret];
    
    continueWithToken(token);
}

@end
