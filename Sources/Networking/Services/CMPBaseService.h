//
//  CMPBaseService.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 22/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPAPIConfiguration.h"
#import "CMPRequestManager.h"
#import "CMPSessionManager.h"

@interface CMPBaseService : NSObject

@property (nonatomic, strong) NSString *apiSpaceID;
@property (nonatomic, strong) CMPAPIConfiguration *apiConfiguration;
@property (nonatomic, strong) CMPRequestManager *requestManager;
@property (nonatomic, strong) id<CMPSessionAuthProvider> sessionAuthProvider;

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID apiConfiguration:(CMPAPIConfiguration *)configuration requestManager:(CMPRequestManager *)requestManager sessionAuthProvider:(id<CMPSessionAuthProvider>)authProvider;

@end
