//
//  CMPSendMessagesTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 09/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"
#import "CMPSendableMessage.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SendMessagesTemplate)
@interface CMPSendMessagesTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, strong) NSString *conversationID;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) CMPSendableMessage *message;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID conversationID:(NSString *)conversationID message:(CMPSendableMessage *)message token:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
