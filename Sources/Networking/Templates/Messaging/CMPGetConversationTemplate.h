//
//  CMPGetConversationTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(GetConversationTemplate)
@interface CMPGetConversationTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, strong) NSString *conversationID;
@property (nonatomic, strong) NSString *token;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID conversationID:(NSString *)converstionID token:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
