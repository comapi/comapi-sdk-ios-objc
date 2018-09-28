//
//  AppDelegate.m
//  SampleApp
//
//  Created by Dominik Kowalski on 31/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "AppDelegate.h"


NSString * const kCMPPushRegistrationStatusChangedNotification = @"CMPPushRegistrationStatusChangedNotification";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UNUserNotificationCenter.currentNotificationCenter.delegate = self;
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.configurator = [[CMPAppConfigurator alloc] initWithWindow:self.window];
    [self.configurator start];
    
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
    completionHandler();
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
