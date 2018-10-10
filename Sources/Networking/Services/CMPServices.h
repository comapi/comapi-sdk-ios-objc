//
//  CMPServices.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 22/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSessionService.h"
#import "CMPProfileService.h"
#import "CMPMessagingService.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Services)
@interface CMPServices : NSObject

@property (nonatomic, strong) id<CMPSessionServiceable> session;
@property (nonatomic, strong) id<CMPProfileServiceable> profile;
@property (nonatomic, strong) id<CMPMessagingServiceable> messaging;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID apiConfiguration:(CMPAPIConfiguration *)configuration requestManager:(CMPRequestManager *)requestManager sessionAuthProvider:(id<CMPSessionAuthProvider>)authProvider;

@end

NS_ASSUME_NONNULL_END
