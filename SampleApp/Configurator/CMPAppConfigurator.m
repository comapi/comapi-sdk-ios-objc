//
//  CMPAppConfigurator.m
//  SampleApp
//
//  Created by Dominik Kowalski on 31/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAppConfigurator.h"
#import "CMPProfileViewController.h"

@interface CMPAppConfigurator ()

@property (nonatomic, strong, nullable) CMPLoginBundle *loginInfo;

- (CMPLoginBundle *)checkForLoginInfo;

@end

@implementation CMPAppConfigurator

- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super init];
    
    if (self) {
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

- (void)start {
    CMPLoginViewModel *vm = [[CMPLoginViewModel alloc] init];
    CMPLoginViewController *vc = [[CMPLoginViewController alloc] initWithViewModel:vm];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    CMPLoginBundle *loginInfo = [self checkForLoginInfo];
    if (loginInfo && [loginInfo isValid]) {
        self.loginInfo = loginInfo;
        CMPComapiConfig *config = [[CMPComapiConfig alloc] initWithApiSpaceID:loginInfo.apiSpaceID authenticationDelegate:self];
        NSError *error = nil;
        self.client = [CMPComapi initialiseWithConfig:config error:&error];
        if (error) {
            [NSException raise:@"failed client init" format:@""];
        }
        __weak typeof(self) weakSelf = self;
        //[self.client.services.session startSessionWithCompletion:^{
        CMPProfileViewModel *vm = [[CMPProfileViewModel alloc] initWithClient:weakSelf.client];
        CMPProfileViewController *vc = [[CMPProfileViewController alloc] initWithViewModel:vm];
        
        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
        [nav pushViewController:vc animated:YES];
//        } failure:^(NSError * _Nullable error) {
//            NSLog(@"%@", [error localizedFailureReason]);
//        }];
    }
}

- (void)restart {
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    [defaults setObject:nil forKey:@"loginInfo"];
    [defaults synchronize];
    
    logWithLevel(CMPLogLevelWarning, @"restarting...", nil);
    
    [self.client.services.session endSessionWithCompletion:^(CMPRequestTemplateResult * _Nonnull result) {
        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
        [nav popToRootViewControllerAnimated:YES];
    }];
}

- (void)clientWith:(CMPComapiClient *)client didReceiveAuthenticationChallenge:(CMPAuthenticationChallenge *)challenge completion:(void (^)(NSString * _Nullable))continueWithToken {
    NSString *token = [CMPAuthenticationManager generateTokenForNonce:challenge.nonce profileID:self.loginInfo.profileID issuer:self.loginInfo.issuer audience:self.loginInfo.audience secret:self.loginInfo.secret];
    
    continueWithToken(token);
}

@end
