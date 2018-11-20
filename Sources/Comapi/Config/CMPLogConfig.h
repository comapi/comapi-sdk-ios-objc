//
//  CMPLogConfig.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 28/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPLogLevel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Defines the verbosity of logs displayed to the implementer and saved to disk.
 */
NS_SWIFT_NAME(LogConfig)
@interface CMPLogConfig : NSObject

@property (class, nonatomic, readwrite) CMPLogLevel logLevel;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
