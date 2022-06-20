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

#import "CMPAppConfigurator.h"
#import "CMPAuthenticationManager.h"
#import "CMPConversationsViewController.h"
#import "CMPProfileViewController.h"
#import "AppDelegate.h"

#import <UserNotifications/UserNotifications.h>

@interface CMPAppConfigurator ()

@property (nonatomic, weak, nullable) AppDelegate *appDelegate;
@property (nonatomic, strong, nullable) CMPLoginBundle *loginInfo;

- (CMPLoginBundle *)checkForLoginInfo;

@end

@implementation CMPAppConfigurator

- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super init];
    
    if (self) {
        self.appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
        self.window = window;
    }
    
    return self;
}

- (CMPLoginBundle *)checkForLoginInfo {
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    NSData *data = [defaults objectForKey:@"loginInfo"];
    [defaults synchronize];
    CMPLoginBundle *bundle = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (bundle) {
        return bundle;
    }
    
    return nil;
}

- (void)start:(void (^ _Nullable)(CMPComapiClient * _Nullable, NSError * _Nullable))completion {
    CMPLoginViewModel *vm = [[CMPLoginViewModel alloc] init];
    CMPLoginViewController *vc = [[CMPLoginViewController alloc] initWithViewModel:vm];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    CMPLoginBundle *loginInfo = [self checkForLoginInfo];
    if (loginInfo && [loginInfo isValid]) {
        self.loginInfo = loginInfo;
        
        NSDictionary<NSString *, id> *info = [NSBundle.mainBundle infoDictionary];
        NSString *scheme = info[@"SERVER_SCHEME"];
        NSString *host = info[@"SERVER_HOST"];
        NSNumber *port = info[@"SERVER_PORT"];
        
        CMPAPIConfiguration *apiConfig = [[CMPAPIConfiguration alloc] initWithScheme:scheme host:host port:port.integerValue];
        
        CMPComapiConfig *config = [[[[[[CMPComapiConfig alloc] init]
                                      setApiSpaceID:loginInfo.apiSpaceID]
                                     setApiConfig:apiConfig]
                                    setAuthDelegate:self]
                                   setLogLevel:CMPLogLevelDebug];
        
        self.client = [CMPComapi initialiseWithConfig:config];
        
        if (!self.client) {
            NSLog(@"failed client init");
        }
        
        __weak typeof(self) weakSelf = self;
        [self.client.services.session startSessionWithCompletion:^{
            [self handleSessionStartedBy:weakSelf withCompletion:completion];
        } failure:^(NSError * _Nullable error) {
            NSLog(@"%@", error);
            if (completion) {
                completion(nil, error);
            }
        }];
    }
}

-(void)handleSessionStartedBy:(CMPAppConfigurator*)handler withCompletion:(void (^ _Nullable)(CMPComapiClient * _Nullable, NSError * _Nullable))completion   {
    [handler.client.services.profile getProfileWithProfileID:self.client.profileID completion:^(CMPResult<CMPProfile *> * result) {
        CMPConversationsViewModel *vm = [[CMPConversationsViewModel alloc] initWithClient:handler.client profile:result.object];
        CMPConversationsViewController *vc = [[CMPConversationsViewController alloc] initWithViewModel:vm];
        
        UINavigationController *nav = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
        [nav pushViewController:vc animated:YES];
        
        if (completion) {
            completion(handler.client, result.error);
        }
    }];
}

- (void)restart {
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    [defaults setObject:nil forKey:@"loginInfo"];
    [defaults synchronize];
    
    logWithLevel(CMPLogLevelWarning, @"restarting...", nil);
    
    [self.client.services.session endSessionWithCompletion:^(CMPResult<NSNumber *> *result) {
        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
        [nav popToRootViewControllerAnimated:YES];
    }];
}

- (void)client:(CMPComapiClient *)client didReceiveAuthenticationChallenge:(CMPAuthenticationChallenge *)challenge completion:(void (^)(NSString * _Nullable))continueWithToken {
    NSString *token = [CMPAuthenticationManager generateTokenForNonce:challenge.nonce profileID:self.loginInfo.profileID issuer:self.loginInfo.issuer audience:self.loginInfo.audience secret:self.loginInfo.secret];
    
    continueWithToken(token);
}

@end
