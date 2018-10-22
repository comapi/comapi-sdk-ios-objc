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
