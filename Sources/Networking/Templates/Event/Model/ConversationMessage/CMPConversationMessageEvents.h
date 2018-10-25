//
//  CMPConversationMessageEvents.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 11/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPEvent.h"
#import "CMPMessageContext.h"
#import "CMPMessagePart.h"
#import "CMPMessageAlert.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ConversationMessage

@interface CMPConversationMessageEvent : CMPEvent

@property (nonatomic, strong, nullable) NSString *conversationEventID;

@end

#pragma mark - Delivered

@interface CMPConversationMessageEventDeliveredPayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSString *messageID;
@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSDate *timestamp;

@end

@interface CMPConversationMessageEventDelivered : CMPConversationMessageEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationMessageEventDeliveredPayload *payload;

@end

#pragma mark - Read

@interface CMPConversationMessageEventReadPayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSString *messageID;
@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSDate *timestamp;

@end

@interface CMPConversationMessageEventRead : CMPConversationMessageEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationMessageEventReadPayload *payload;

@end

#pragma mark - Sent

@interface CMPConversationMessageEventSentPayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSString *messageID;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *metadata;
@property (nonatomic, strong, nullable) NSArray<CMPMessagePart *> *parts;
@property (nonatomic, strong, nullable) CMPMessageContext *context;
@property (nonatomic, strong, nullable) CMPMessageAlert *alert;

@end

@interface CMPConversationMessageEventSent : CMPConversationMessageEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSDate *publishedOn;
@property (nonatomic, strong, nullable) CMPConversationMessageEventSentPayload *payload;

@end

NS_ASSUME_NONNULL_END
