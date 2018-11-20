//
//  CMPComapi.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPComapiClient.h"
#import "CMPComapiConfig.h"

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Client interface class used for initializing and retrieving CMPComapiClient.
 */
NS_SWIFT_NAME(Comapi)
@interface CMPComapi : NSObject

/**
 @discussion Singleton client instance.
 @warning Only available if you call:
 @code + (nullable CMPComapiClient *)initialiseSharedInstanceWithConfig:(CMPComapiConfig *)config; @endcode
 */
@property (class, nonatomic, strong, readonly, nullable) CMPComapiClient *shared;

- (instancetype)init NS_UNAVAILABLE;

/**
 @brief Creates an instance of CMPComapiClient with given configuration.
 @param config CMPComapiConfig object created with specified configuration elements.
 @return CMPComapiClient object or nil if error occurs.
 */
+ (nullable CMPComapiClient *)initialiseWithConfig:(CMPComapiConfig *)config;

/**
 @discussion Creates an instance of CMPComapiClient with given configuration that can be accessed via: @code [CMPComapi shared]; @endcode
 @param config CMPComapiConfig object created with specified configuration elements.
 @return CMPComapiClient object or nil if error occurs.
 */
+ (nullable CMPComapiClient *)initialiseSharedInstanceWithConfig:(CMPComapiConfig *)config;

@end

NS_ASSUME_NONNULL_END
