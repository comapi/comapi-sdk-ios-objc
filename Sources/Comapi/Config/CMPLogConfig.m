//
//  CMPLogConfig.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 28/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPLogConfig.h"

@implementation CMPLogConfig

static CMPLogLevel _logLevel = CMPLogLevelVerbose;

+ (void)setLogLevel:(CMPLogLevel)logLevel {
    _logLevel = logLevel;
}

+ (CMPLogLevel)logLevel {
    return _logLevel;
}

@end
