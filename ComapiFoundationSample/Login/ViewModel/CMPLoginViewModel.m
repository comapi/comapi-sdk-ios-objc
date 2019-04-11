//
// The MIT License (MIT)
// Copyright (c) 2017 Comapi (trading name of Dynmark International Limited)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "CMPLoginViewModel.h"
#import "AppDelegate.h"
#import "CMPAuthenticationManager.h"

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
    
    CMPAPIConfiguration *apiConfig = CMPAPIConfiguration.production;
    CMPComapiConfig *config = [[[[[[CMPComapiConfig builder] setApiSpaceID:self.loginBundle.apiSpaceID] setApiConfig:apiConfig] setAuthDelegate:self] setLogLevel:CMPLogLevelDebug] build];
    self.client = [CMPComapi initialiseWithConfig:config];
    if (!self.client) {
        NSLog(@"failed client init");
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
