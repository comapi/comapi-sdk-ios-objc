//
//  CMPClient.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAuthenticationDelegate.h"
#import "CMPAPIConfiguration.h"
#import "CMPRequestManager.h"
#import "CMPServices.h"

typedef NS_ENUM(NSUInteger, CMPSDKState) {
    CMPSDKStateNotInitialised,
    CMPSDKStateInitilised,
    CMPSDKStateInitialising,
    CMPSDKStateSessionOff,
    CMPSDKStateSessionStarting,
    CMPSDKStateSessionActive
};

@interface CMPComapiClient : NSObject <CMPRequestManagerDelegate>

@property (nonatomic) CMPSDKState state;
@property (nonatomic) CMPServices *services;

- (NSString *)profileID;
- (BOOL)isSessionSuccessfullyCreated;
- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate apiConfiguration:(CMPAPIConfiguration *)configuration;
- (void)setPushToken:(NSString *)token completion:(void(^)(BOOL, NSError *))completion;

@end
