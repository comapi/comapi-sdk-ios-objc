//
//  CMPProfileViewModel.h
//  SampleApp
//
//  Created by Dominik Kowalski on 12/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPComapiClient.h"
#import "CMPProfile.h"

@interface CMPProfileViewModel : NSObject

@property (nonatomic, strong) CMPComapiClient *client;
@property (nonatomic, strong) NSMutableArray<CMPProfile *> *profiles;

- (instancetype)initWithClient:(CMPComapiClient *)client;
- (void)getProfilesWithCompletion:(void(^)(NSError * _Nullable))completion;
- (void)registerForRemoteNotificationsWithCompletion:(void (^)(BOOL, NSError * _Nonnull))completion;

@end
