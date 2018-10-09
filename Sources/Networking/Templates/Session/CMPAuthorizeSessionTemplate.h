//
//  CMPAuthorizationSessionTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 23/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"
#import "CMPAuthorizeSessionBody.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AuthorizeSessionTemplate)
@interface CMPAuthorizeSessionTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, nonnull, strong) CMPAuthorizeSessionBody *body;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID body:(CMPAuthorizeSessionBody *)body;

@end

NS_ASSUME_NONNULL_END
