//
//  CMPAPIConfiguration.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAPIConfiguration.h"

NSString * const CMPProductionScheme = @"https";
NSString * const CMPProductionHost = @"api.comapi.com";
NSUInteger const CMPProductionPort = 443;

@implementation CMPAPIConfiguration

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port {
    self = [super init];
    
    if (self) {
        self.host = host;
        self.scheme = scheme;
        self.port = port;
    }
    
    return self;
}

+ (instancetype)production {
    return [[CMPAPIConfiguration alloc] initWithScheme:CMPProductionScheme host:CMPProductionHost port:CMPProductionPort];
}

@end
