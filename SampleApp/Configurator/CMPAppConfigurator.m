//
//  CMPAppConfigurator.m
//  SampleApp
//
//  Created by Dominik Kowalski on 31/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAppConfigurator.h"


@interface CMPAppConfigurator ()

@property (nonatomic, strong, nullable) CMPLoginBundle *loginInfo;
@property (nonatomic, strong, nullable) CMPComapiClient *client;

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
    CMPLoginBundle *bundle = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (bundle) {
        return bundle;
    }
    
    return nil;
}

- (void)start {
    CMPLoginBundle *loginInfo = [self checkForLoginInfo];
    if (loginInfo && [loginInfo isValid]) {
        self.loginInfo = loginInfo;
        CMPComapiConfig *config = [[CMPComapiConfig alloc] initWithApiSpaceID:loginInfo.apiSpaceID authenticationDelegate:self];
        NSError *error = nil;
        CMPComapiClient *client = [CMPComapi initialiseWithConfig:config error:&error];
        if (error) {
            [NSException raise:@"failed client init" format:@""];
        }
        __weak CMPAppConfigurator *weakSelf = self;
        [client.services.session startSessionWithCompletion:^{
            NSLog(@"success");
        } failure:^(NSError * _Nullable error) {
            NSLog(@"%@", [error localizedFailureReason]);
        }];
    } else {
        CMPLoginViewModel *vm = [[CMPLoginViewModel alloc] init];
        CMPLoginViewController *vc = [[CMPLoginViewController alloc] initWithViewModel:vm];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
}

- (void)restart {
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    [defaults setObject:nil forKey:@"loginInfo"];
    NSLog(@"restarting...");
}

- (void)clientWith:(CMPComapiClient *)client didReceiveAuthenticationChallenge:(CMPAuthenticationChallenge *)challenge completion:(void (^)(NSString * _Nullable))continueWithToken {
    NSString *token = [CMPAuthenticationManager generateTokenForNonce:challenge.nonce profileID:self.loginInfo.profileID issuer:self.loginInfo.issuer audience:self.loginInfo.audience secret:self.loginInfo.secret];
    
    continueWithToken(token);
}

//client?.services.session.startSession(completion: { [weak self] in
//    guard let `self` = self else { return }
//    let rootController = ConversationViewController(viewModel: ConversationViewModel(client: self.client!))
//    let navController = UINavigationController(rootViewController: rootController)
//
//    self.window.makeKeyAndVisible()
//    self.window.rootViewController = navController
//}) { (error) in
//    fatalError("error starting session")
//}
//} else {
//    let rootController = LoginViewController(viewModel: LoginViewModel())
//    let navController = UINavigationController(rootViewController: rootController)
//
//    window.makeKeyAndVisible()
//    window.rootViewController = navController
//}
//}
//
//func restart() {
//    UserDefaults.standard.set(nil, forKey: "loginInfo")
//    let rootController = LoginViewController(viewModel: LoginViewModel())
//    let navController = UINavigationController(rootViewController: rootController)
//
//    window.makeKeyAndVisible()
//    window.rootViewController = navController
//}

@end
