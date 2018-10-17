//
//  CMPChatViewModel.m
//  SampleApp
//
//  Created by Dominik Kowalski on 15/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPChatViewModel.h"
#import "CMPEventParser.h"
#import "CMPConversationMessageEvents.h"

@implementation CMPChatViewModel

- (instancetype)initWithClient:(CMPComapiClient *)client conversation:(CMPConversation *)conversation {
    self = [super init];
    
    if (self) {
        self.client = client;
        self.conversation = conversation;
        self.messages = @[];
        
        [self.client addEventDelegate:self];
    }
    
    return self;
}

- (void)getMessagesWithCompletion:(void (^)(NSArray<CMPMessage *> * _Nullable, NSError * _Nullable))completion {
    [self.client.services.messaging getMessagesWithConversationID:self.conversation.id limit:100 from:0 completion:^(CMPGetMessagesResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
        } else {
            self.messages = result.messages ? result.messages : @[];
            completion(result.messages, nil);
        }
    }];
}

- (void)sendTextMessage:(NSString *)message completion:(void (^)(NSError * _Nullable))completion {
    NSDictionary<NSString *, id> *metadata = @{@"myMessageID" : @"123"};
    CMPMessagePart *part = [[CMPMessagePart alloc] initWithName:@"" type:@"text/plain" url:nil data:message size:[NSNumber numberWithUnsignedLong:sizeof(message.UTF8String)]];
    CMPSendableMessage *sendableMessage = [[CMPSendableMessage alloc] initWithMetadata:metadata parts:@[part] alert:nil];
    [self.client.services.messaging sendMessage:sendableMessage toConversationWithID:self.conversation.id completion:^(CMPSendMessagesResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            completion(error);
        } else {
            completion(nil);
        }
    }];
}

#pragma mark - CMPEventDelegate

- (void)client:(CMPComapiClient *)client didReceiveEvent:(CMPEvent *)event {
    if ([event.name isEqualToString:@"conversationMessage.sent"]) {
        CMPConversationMessageEventSent *sentEvent = (CMPConversationMessageEventSent *)event;
        NSString *messageID = sentEvent.payload.messageID;
        NSDictionary *metadata = sentEvent.payload.metadata;
        CMPMessageContext *context = sentEvent.payload.context;
        NSArray<CMPMessagePart *> *parts = sentEvent.payload.parts;
        
        __block BOOL contains = NO;
        [self.messages enumerateObjectsUsingBlock:^(CMPMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.id isEqualToString:messageID]) {
                contains = YES;
                *stop = YES;
            }
        }];
        if (contains) {
            return;
        }
        CMPMessage *message = [[CMPMessage alloc] initWithID:messageID metadata:metadata context:context parts:parts statusUpdates:nil];
        self.messages = [self.messages arrayByAddingObject:message];
        if (self.didReceiveMessage) {
            self.didReceiveMessage();
        }
    }
}

@end
