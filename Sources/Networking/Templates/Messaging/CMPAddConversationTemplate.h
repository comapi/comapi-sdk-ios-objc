//
//  CMPAddConversationTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"
#import "CMPNewConversation.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AddConversationTemplate)
@interface CMPAddConversationTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, strong) CMPNewConversation *conversation;
@property (nonatomic, strong) NSString *token;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID conversation:(CMPNewConversation *)conversation token:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
