//
//  CMPServices.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 22/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSessionService.h"
#import "CMPProfileService.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPServices : NSObject

@property (nonatomic, strong) CMPSessionService *session;
@property (nonatomic, strong) CMPProfileService *profile;

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID apiConfiguration:(CMPAPIConfiguration *)configuration requestManager:(CMPRequestManager *)requestManager sessionAuthProvider:(id<CMPSessionAuthProvider>)authProvider;

@end

NS_ASSUME_NONNULL_END
