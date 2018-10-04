//
//  CMPEventQueryTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(EventQueryTemplate)
@interface CMPEventQueryTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *conversationID;
@property (nonatomic) NSUInteger from;
@property (nonatomic) NSUInteger limit;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID conversationID:(NSString *)conversationID from:(NSUInteger)from limit:(NSUInteger)limit token:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
