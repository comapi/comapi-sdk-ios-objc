//
//  CMPServices.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 22/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPServices.h"

@implementation CMPServices

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID apiConfiguration:(CMPAPIConfiguration *)configuration requestManager:(CMPRequestManager *)requestManager sessionAuthProvider:(id<CMPSessionAuthProvider>)authProvider {
    self = [super init];
    
    if (self) {
        self.profile = [[CMPProfileService alloc] initWithApiSpaceID:apiSpaceID apiConfiguration:configuration requestManager:requestManager sessionAuthProvider:authProvider];
        self.session = [[CMPSessionService alloc] initWithApiSpaceID:apiSpaceID apiConfiguration:configuration requestManager:requestManager sessionAuthProvider:authProvider];
    }
    
    return self;
}

@end
