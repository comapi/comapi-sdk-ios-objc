//
//  CMPComapi.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPComapi.h"

@interface CMPComapi ()

@end

@implementation CMPComapi

static CMPComapiClient *_shared = nil;

+ (void)setShared:(CMPComapiClient *)shared {
    _shared = shared;
}

+ (CMPComapiClient *)shared {
    CMPComapiClient *client = _shared;
    if (!client) {
        return nil;
    }
    return client;
}

+ (CMPComapiClient *)initialiseWithConfig:(CMPComapiConfig *)config {
    CMPComapiClient *instance = [[CMPComapiClient alloc] initWithApiSpaceID:config.id authenticationDelegate:config.authDelegate apiConfiguration:config.apiConfig];
    
    logWithLevel(CMPLogLevelInfo, @"Client initialised.", nil);
    
    return instance;
}

+ (CMPComapiClient *)initialiseSharedInstanceWithConfig:(CMPComapiConfig *)config {
    if (_shared != nil) {
        logWithLevel(CMPLogLevelError, @"Client already initialised, returnig current client...", nil);
        return _shared;
    }
    
    [self setShared:[[CMPComapiClient alloc] initWithApiSpaceID:config.id authenticationDelegate:config.authDelegate apiConfiguration:config.apiConfig]];
    
    logWithLevel(CMPLogLevelInfo, @"Shared client initialised.", nil);
    
    return _shared;
}


@end
