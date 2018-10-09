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

NS_SWIFT_NAME(Comapi)
@interface CMPComapi : NSObject

@property (class, nonatomic, strong, readonly, nullable) CMPComapiClient *shared;

- (instancetype)init NS_UNAVAILABLE;

+ (nullable CMPComapiClient *)initialiseWithConfig:(CMPComapiConfig *)config;
+ (nullable CMPComapiClient *)initialiseSharedInstanceWithConfig:(CMPComapiConfig *)config;

@end

NS_ASSUME_NONNULL_END
