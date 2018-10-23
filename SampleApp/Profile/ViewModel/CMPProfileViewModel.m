//
//  CMPProfileViewModel.m
//  SampleApp
//
//  Created by Dominik Kowalski on 12/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPProfileViewModel.h"

#import <UserNotifications/UserNotifications.h>

@implementation CMPProfileViewModel

- (instancetype)initWithClient:(CMPComapiClient *)client {
    self = [super init];
    
    if (self) {
        self.client = client;
        self.profiles = [NSMutableArray new];
    }
    
    return self;
}

- (void)getProfilesWithCompletion:(void(^)(NSError * _Nullable))completion {
    __weak typeof(self) weakSelf = self;
    [self.client.services.profile queryProfilesWithQueryElements:@[] completion:^(NSArray<CMPProfile *> * profiles, NSError * error) {
        if (error) {
            completion(error);
        } else {
            weakSelf.profiles = [profiles mutableCopy];
            completion(nil);
        }
    }];
}

- (void)registerForRemoteNotificationsWithCompletion:(void (^)(BOOL, NSError * _Nonnull))completion {
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        completion(granted, error);
    }];
}

@end
