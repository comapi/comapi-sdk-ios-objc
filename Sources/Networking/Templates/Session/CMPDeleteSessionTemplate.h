//
//  CMPDeleteSessionTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 27/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(DeleteSessionTemplate)
@interface CMPDeleteSessionTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *sessionID;

- (instancetype) initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID token:(NSString *)token sessionID:(NSString *)sessionID;

@end

NS_ASSUME_NONNULL_END
