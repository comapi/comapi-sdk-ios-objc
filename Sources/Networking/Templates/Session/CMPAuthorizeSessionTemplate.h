//
//  CMPAuthorizationSessionTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 23/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"
#import "CMPAuthorizeSessionBody.h"

@interface CMPAuthorizeSessionTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, nonnull, strong) CMPAuthorizeSessionBody *body;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID body:(CMPAuthorizeSessionBody *)body;

@end
