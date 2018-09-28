//
//  CMPConfig.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPComapiConfig.h"
#import "CMPLogConfig.h"

@interface CMPComapiConfig ()

@end

@implementation CMPComapiConfig

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)authenticationDelegate {
    self = [super init];
    
    if (self) {
        _apiConfig = CMPAPIConfiguration.production;
        _id = apiSpaceID;
        _authDelegate = authenticationDelegate;
        _logLevel = CMPLogLevelVerbose;
        
        [self setLogLevel:_logLevel];
    }
    
    return self;
}

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)authenticationDelegate logLevel:(CMPLogLevel)logLevel {
    self = [self initWithApiSpaceID:apiSpaceID authenticationDelegate:authenticationDelegate];
    
    if (self) {
        _logLevel = logLevel;
        
        [self setLogLevel:_logLevel];
    }
    
    return self;
}

- (void)setLogLevel:(CMPLogLevel)logLevel {
    _logLevel = logLevel;
    [CMPLogConfig setLogLevel:self.logLevel];
    [[CMPLogger shared] resetDestinations];
}

@end
