//
//  CMPComapi.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPComapi.h"
#import "CMPErrors.h"

@interface CMPComapi ()

@property (class, nonatomic, strong, nullable) CMPComapiClient *shared;

@end

@implementation CMPComapi

static CMPComapiClient *_shared = nil;

+ (void)setShared:(CMPComapiClient *)shared {
    _shared = shared;
}

+ (CMPComapiClient *)shared {
    return _shared;
}

+ (CMPComapiClient *)shared:(NSError **)error {
    CMPComapiClient *client = [CMPComapi shared];
    if (!client) {
        *error = [CMPErrors comapiErrorWithStatus:CMPComapiErrorNotInitialised underlyingError:nil];
        return nil;
    }
    return client;
}

+ (CMPComapiClient *)initialiseWithConfig:(CMPComapiConfig *)config error:(NSError *__autoreleasing *)error {
    CMPComapiClient *instance = [[CMPComapiClient alloc] initWithApiSpaceID:config.id authenticationDelegate:config.authDelegate apiConfiguration:config.apiConfig];
    
    logWithLevel(CMPLogLevelInfo, instance, @"some random stuff", nil);
    
    return instance;
}

+ (CMPComapiClient *)initialiseSharedInstanceWithConfig:(CMPComapiConfig *)config error:(NSError *__autoreleasing *)error {
    if ([CMPComapi shared]) {
        *error = [CMPErrors comapiErrorWithStatus:CMPComapiErrorAlreadyInitialised underlyingError:nil];
        return nil;
    }
    
    [self setShared:[[CMPComapiClient alloc] initWithApiSpaceID:config.id authenticationDelegate:config.authDelegate apiConfiguration:config.apiConfig]];
    
    return _shared;
}


@end
