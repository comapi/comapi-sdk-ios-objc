//
//  CMPGetConversationsTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPGetConversationsTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, strong, nullable) NSString *conversationScope;
@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong) NSString *token;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID profileID:(nullable NSString *)profileID scope:(nullable NSString *)scope token:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
