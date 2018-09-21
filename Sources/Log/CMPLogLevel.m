//
//  CMPLogLevel.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 28/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPLogLevel.h"

@implementation CMPLogLevelRepresenter

+ (NSString *)emojiRepresentationForLogLevel:(CMPLogLevel)logLevel {
    switch (logLevel) {
        case CMPLogLevelVerbose:
            return @"⏺";
        case CMPLogLevelDebug:
            return @"🆔";
        case CMPLogLevelInfo:
            return @"🚹";
        case CMPLogLevelWarning:
            return @"☢";
        case CMPLogLevelError:
            return @"🆘";
    }
}

+ (NSString *)textualRepresentationForLogLevel:(CMPLogLevel)logLevel {
    switch (logLevel) {
        case CMPLogLevelVerbose:
            return @"VERBOSE";
        case CMPLogLevelDebug:
            return @"DEBUG";
        case CMPLogLevelInfo:
            return @"INFO";
        case CMPLogLevelWarning:
            return @"WARNING";
        case CMPLogLevelError:
            return @"ERROR";
    }
}

@end
