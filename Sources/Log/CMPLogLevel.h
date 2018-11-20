//
//  CMPLogLevel.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 28/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 @typedef CMPLogLevel
 @brief Defines the verbosity of logs.
 */
typedef NS_ENUM(NSUInteger, CMPLogLevel) {
    /// Most verbose debugging level - displays everything.
    CMPLogLevelVerbose = 0,
    /// Less verbose level.
    CMPLogLevelDebug,
    /// Only displays crucial information, warnings and errors.
    CMPLogLevelInfo,
    /// Only displays warnings and errors.
    CMPLogLevelWarning,
    /// Only displays errors.
    CMPLogLevelError
} NS_SWIFT_NAME(LogLevel);

NS_SWIFT_NAME(LogLevelRepresenter)
@interface CMPLogLevelRepresenter: NSObject

+ (NSString *)emojiRepresentationForLogLevel:(CMPLogLevel)logLevel;
+ (NSString *)textualRepresentationForLogLevel:(CMPLogLevel)logLevel;

@end

NS_ASSUME_NONNULL_END
