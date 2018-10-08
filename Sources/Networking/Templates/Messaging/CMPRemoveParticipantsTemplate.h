//
//  CMPRemoveParticipantsTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"
#import "CMPConversationParticipant.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(RemoveParticipantsTemplate)
@interface CMPRemoveParticipantsTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *conversationID;
@property (nonatomic, strong) NSArray<CMPConversationParticipant *> *participants;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID conversationID:(NSString *)conversationID participants:(NSArray<CMPConversationParticipant *> *)participants token:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
