//
//  CMPLogConfig.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 28/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPLogLevel.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(LogConfig)
@interface CMPLogConfig : NSObject

@property (class, nonatomic, readwrite) CMPLogLevel logLevel;

- (instancetype)init NS_UNAVAILABLE;

+ (CMPLogLevel)logLevel;
+ (void)setLogLevel:(CMPLogLevel)logLevel;

@end

NS_ASSUME_NONNULL_END
