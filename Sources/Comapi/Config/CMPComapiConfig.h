//
// CMPConfig.h
// CMPComapiFoundation
//
// Created by Dominik Kowalski on 21/08/2018.
// Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAPIConfiguration.h"
#import "CMPComapiConfig.h"
#import "CMPAuthenticationDelegate.h"
#import "CMPLogger.h"

NS_ASSUME_NONNULL_BEGIN

/**
 @brief CMPComapiConfig object used for initializing an instance of CMPComapiClient.
 */
NS_SWIFT_NAME(ComapiConfig)
@interface CMPComapiConfig : NSObject
@property (nonatomic, strong, readonly) NSString* id;
@property (nonatomic, strong, readonly) id<CMPAuthenticationDelegate> authDelegate;
@property (nonatomic, strong) CMPAPIConfiguration *apiConfig;
@property (nonatomic) CMPLogLevel logLevel;

- (instancetype)init NS_UNAVAILABLE;

/**
 @brief Initialize a CMPComapiConfig object with a specified CMPLogLevel.
 @param authenticationDelegate An object of class conforming to CMPAuthenticationDelegate, used to establish a session between client and server.
 @param apiSpaceID Specific id obtained from Comapi portal.
 @return CMPComapiConfig object used for initializing an instance of CMPComapiClient.
 */
- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)authenticationDelegate logLevel:(CMPLogLevel)logLevel;

/**
 @brief Initialize a CMPComapiConfig object with a default CMPLogLevel of CMPLogLevelVerbose.
 @param authenticationDelegate An object of class conforming to CMPAuthenticationDelegate, used to establish a session between client and server.
 @param apiSpaceID Specific id obtained from Comapi portal.
 @return CMPComapiConfig object used for initializing an instance of CMPComapiClient.
 */
- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)authenticationDelegate;

@end

NS_ASSUME_NONNULL_END
