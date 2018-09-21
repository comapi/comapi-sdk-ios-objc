//
//  CMPConfig.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPComapiConfig.h"

@implementation CMPComapiConfig

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)authenticationDelegate {
    self = [super init];
    
    if (self) {
        _apiConfig = CMPAPIConfiguration.production;
        _id = apiSpaceID;
        _authDelegate = authenticationDelegate;
    }
    
    return self;
}

@end
