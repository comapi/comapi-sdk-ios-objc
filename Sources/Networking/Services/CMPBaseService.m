//
//  CMPBaseService.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 22/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseService.h"

@implementation CMPBaseService

-(instancetype)initWithApiSpaceID:(NSString *)apiSpaceID apiConfiguration:(CMPAPIConfiguration *)configuration requestManager:(CMPRequestManager *)requestManager sessionAuthProvider:(id<CMPSessionAuthProvider>)authProvider {
    self = [super init];
    
    if (self) {
        self.apiSpaceID = apiSpaceID;
        self.apiConfiguration = configuration;
        self.requestManager = requestManager;
        self.sessionAuthProvider = authProvider;
    }
    
    return self;
}

@end



