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

NS_SWIFT_NAME(ConversationMessageEvent)
@interface CMPConversationMessageEvent : CMPEvent

@property (nonatomic, strong, nullable) NSNumber *conversationEventID;

@end

#pragma mark - Delivered

NS_SWIFT_NAME(ConversationMessageEventDeliveredPayload)
@interface CMPConversationMessageEventDeliveredPayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSString *messageID;
@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSDate *timestamp;

@end

NS_SWIFT_NAME(ConversationMessageEventDelivered)
@interface CMPConversationMessageEventDelivered : CMPConversationMessageEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationMessageEventDeliveredPayload *payload;

@end

#pragma mark - Read

NS_SWIFT_NAME(ConversationMessageEventReadPayload)
@interface CMPConversationMessageEventReadPayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSString *messageID;
@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSDate *timestamp;

@end

NS_SWIFT_NAME(ConversationMessageEventRead)
@interface CMPConversationMessageEventRead : CMPConversationMessageEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationMessageEventReadPayload *payload;

@end

#pragma mark - Sent

NS_SWIFT_NAME(ConversationMessageEventSentPayload)
@interface CMPConversationMessageEventSentPayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSString *messageID;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *metadata;
@property (nonatomic, strong, nullable) NSArray<CMPMessagePart *> *parts;
@property (nonatomic, strong, nullable) CMPMessageContext *context;
@property (nonatomic, strong, nullable) CMPMessageAlert *alert;

@end

NS_SWIFT_NAME(ConversationMessageEventSent)
@interface CMPConversationMessageEventSent : CMPConversationMessageEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSDate *publishedOn;
@property (nonatomic, strong, nullable) CMPConversationMessageEventSentPayload *payload;

@end

NS_ASSUME_NONNULL_END
