//
//  CMPSocketTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 02/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SocketTemplate)
@interface CMPSocketTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, strong) NSString *profileID;
@property (nonatomic, strong) NSString *token;

- (instancetype)init NS_UNAVAILABLE;

-(instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID token:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
