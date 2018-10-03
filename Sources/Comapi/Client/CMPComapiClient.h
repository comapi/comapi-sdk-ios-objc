//
//  CMPClient.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAuthenticationDelegate.h"
#import "CMPAPIConfiguration.h"
#import "CMPRequestManager.h"
#import "CMPServices.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CMPSDKState) {
    CMPSDKStateNotInitialised,
    CMPSDKStateInitilised,
    CMPSDKStateInitialising,
    CMPSDKStateSessionOff,
    CMPSDKStateSessionStarting,
    CMPSDKStateSessionActive
} NS_SWIFT_NAME(SDKState);

NS_SWIFT_NAME(ComapiClient)
@interface CMPComapiClient: NSObject <CMPRequestManagerDelegate>

@property (nonatomic) CMPSDKState state;
@property (nonatomic, strong, readonly) CMPServices *services;
@property (nonatomic, strong, readonly, nullable, getter=getProfileID) NSString *profileID;
@property (nonatomic, readonly, getter=isSessionSuccessfullyCreated) BOOL sessionSuccesfullyCreated;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate apiConfiguration:(CMPAPIConfiguration *)configuration;
- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate apiConfiguration:(CMPAPIConfiguration *)configuration requestPerformer:(id<CMPRequestPerforming>)requestPerformer;
- (void)setPushToken:(NSString *)deviceToken completion:(void(^)(BOOL, NSError * _Nullable))completion NS_SWIFT_NAME(set(pushToken:completion:));

@end

NS_ASSUME_NONNULL_END
