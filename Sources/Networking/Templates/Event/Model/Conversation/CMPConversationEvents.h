//
//  CMPConversationEvent.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 10/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPEvent.h"
#import "CMPRoles.h"
#import "CMPConversationParticipant.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Conversation

@interface CMPConversationEvent : CMPEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSString *conversationEventID;

@end

#pragma mark - Create

@interface CMPConversationEventCreatePayload : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSNumber *isPublic;
@property (nonatomic, strong, nullable) CMPRoles *roles;
@property (nonatomic, strong, nullable) NSArray<CMPConversationParticipant *> *participants;

@end

@interface CMPConversationEventCreate : CMPConversationEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationEventCreatePayload *payload;

@end

#pragma mark - Update

@interface CMPConversationEventUpdatePayload : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSString *eventDescription;
@property (nonatomic, strong, nullable) NSNumber *isPublic;
@property (nonatomic, strong, nullable) CMPRoles *roles;

@end

@interface CMPConversationEventUpdate : CMPConversationEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationEventUpdatePayload *payload;

@end

#pragma mark - Delete

@interface CMPConversationEventDeletePayload : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSDate *date;

@end

@interface CMPConversationEventDelete : CMPConversationEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationEventDeletePayload *payload;

@end

#pragma mark - Undelete

@interface CMPConversationEventUndeletePayload : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSString *eventDescription;
@property (nonatomic, strong, nullable) NSNumber *isPublic;
@property (nonatomic, strong, nullable) CMPRoles *roles;

@end

@interface CMPConversationEventUndelete : CMPConversationEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationEventUndeletePayload *payload;

@end

#pragma mark - ParticipantAdded

@interface CMPConversationEventParticipantAddedPayload : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *apiSpaceID;
@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSString *role;

@end

@interface CMPConversationEventParticipantAdded : CMPConversationEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationEventParticipantAddedPayload *payload;

@end

#pragma mark - ParticipantRemoved

@interface CMPConversationEventParticipantRemovedPayload : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSString *apiSpaceID;

@end

@interface CMPConversationEventParticipantRemoved : CMPConversationEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationEventParticipantRemovedPayload *payload;

@end

#pragma mark - ParticipantUpdated

@interface CMPConversationEventParticipantUpdatedPayload : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSString *apiSpaceID;
@property (nonatomic, strong, nullable) NSString *role;

@end

@interface CMPConversationEventParticipantUpdated : CMPConversationEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationEventParticipantUpdatedPayload *payload;

@end

#pragma mark - ParticipantTyping

@interface CMPParticipantTypingEvent : CMPEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *accountID;
@property (nonatomic, strong, nullable) NSDate *publishedOn;

@end

#pragma mark - ParticipantTypingOn

@interface CMPConversationEventParticipantTypingPayload : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSString *conversationID;

@end

@interface CMPConversationEventParticipantTyping : CMPParticipantTypingEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationEventParticipantTypingPayload *payload;

@end

#pragma mark - ParticipantTypingOff

@interface CMPConversationEventParticipantTypingOffPayload : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSString *conversationID;

@end

@interface CMPConversationEventParticipantTypingOff : CMPParticipantTypingEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationEventParticipantTypingOffPayload *payload;

@end

NS_ASSUME_NONNULL_END
