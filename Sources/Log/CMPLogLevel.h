//
//  CMPLogLevel.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 28/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CMPLogLevel) {
    CMPLogLevelVerbose = 0,
    CMPLogLevelDebug,
    CMPLogLevelInfo,
    CMPLogLevelWarning,
    CMPLogLevelError
};

@interface CMPLogLevelRepresenter: NSObject

+ (NSString *)emojiRepresentationForLogLevel:(CMPLogLevel)logLevel;
+ (NSString *)textualRepresentationForLogLevel:(CMPLogLevel)logLevel;

@end

NS_ASSUME_NONNULL_END
