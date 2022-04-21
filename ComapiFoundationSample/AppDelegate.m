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

#import "AppDelegate.h"
#import "CMPChatViewController.h"

NSString * const kCMPPushRegistrationStatusChangedNotification = @"CMPPushRegistrationStatusChangedNotification";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UNUserNotificationCenter.currentNotificationCenter.delegate = self;
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.configurator = [[CMPAppConfigurator alloc] initWithWindow:self.window];
    [self.configurator start:nil];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSMutableString *token = [NSMutableString string];
    
    const char *data = [deviceToken bytes];
    for (NSUInteger i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%.2hhx", data[i]];
    }
    
    if (token) {
        CMPComapiClient *client = self.configurator.client;
        if (client) {
            [client setPushToken:token completion:^(BOOL success, NSError * error) {
                if (error || !success) {
                    NSLog(@"%@", error.localizedDescription);
                    [[NSNotificationCenter defaultCenter] postNotificationName:kCMPPushRegistrationStatusChangedNotification object:@(NO) userInfo:nil];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kCMPPushRegistrationStatusChangedNotification object:@(YES) userInfo:nil];
                }
            }];
        }
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
    [[NSNotificationCenter defaultCenter] postNotificationName:kCMPPushRegistrationStatusChangedNotification object:@(NO) userInfo:nil];
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler((UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound));
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    __weak typeof(self) weakSelf = self;
    [self.configurator start:^(CMPComapiClient * _Nullable client, NSError * _Nullable error) {
        [client handleNotificationResponse:response completion:^(BOOL isDeppLinkLunched, NSDictionary * _Nonnull data) {
            NSString *conversationId = data[@"conversationId"];
            if (conversationId) {
                UINavigationController *nav = (UINavigationController *)weakSelf.configurator.window.rootViewController;
                NSString *conversationId = response.notification.request.content.userInfo[@"conversationId"];
                [client.services.messaging getConversationWithConversationID:conversationId completion:^(CMPResult<CMPConversation *> * _Nonnull result) {
                    if (result.error) {
                        NSLog(@"%@", result.error)
                    } else {
                        CMPChatViewModel *vm = [[CMPChatViewModel alloc] initWithClient:client conversation:result.object];
                        CMPChatViewController *vc = [[CMPChatViewController alloc] initWithViewModel:vm];
                
                        [nav pushViewController:vc animated:YES];
                    }
                
                    completionHandler();
                }];
            } else if (data[@"dd_deepLink"] && !isDeppLinkLunched) {
                NSString *url = data[@"dd_deepLink"][@"url"];
                NSString *message = [NSString stringWithFormat:@"Received in-app link- %@", url];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"dotdigital Deep Link" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
                while (topController.presentedViewController) {
                    topController = topController.presentedViewController;
                }
                [topController presentViewController:alertController animated:YES completion:nil];
            }
        }];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication.sharedApplication setApplicationIconBadgeNumber:0];
    });
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
