//
//  CMPBaseService.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 22/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAPIConfiguration.h"
#import "CMPRequestManager.h"
#import "CMPSessionAuthProvider.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(BaseService)
@interface CMPBaseService : NSObject

@property (nonatomic, strong) NSString *apiSpaceID;
@property (nonatomic, strong) CMPAPIConfiguration *apiConfiguration;
@property (nonatomic, strong) CMPRequestManager *requestManager;
@property (nonatomic, strong) id<CMPSessionAuthProvider> sessionAuthProvider;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID apiConfiguration:(CMPAPIConfiguration *)configuration requestManager:(CMPRequestManager *)requestManager sessionAuthProvider:(id<CMPSessionAuthProvider>)authProvider;

@end

NS_ASSUME_NONNULL_END
