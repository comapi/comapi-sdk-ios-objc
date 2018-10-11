//
//  CMPConversationEvent.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 10/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPConversationEvents.h"
#import "NSString+CMPUtility.h"

#pragma mark - Conversation

@implementation CMPConversationEvent

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
        if (JSON[@"conversationEventId"] && [JSON[@"conversationEventId"] isKindOfClass:NSString.class]) {
            self.conversationEventID = JSON[@"conversationEventId"];
        }
    }
    
    return self;
}

@end

#pragma mark - Create

@implementation CMPConversationEventCreate

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationEventCreatePayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
}

@end

@implementation CMPConversationEventCreatePayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"id"] && [JSON[@"id"] isKindOfClass:NSString.class]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"name"] && [JSON[@"name"] isKindOfClass:NSString.class]) {
            self.name = JSON[@"name"];
        }
        if (JSON[@"isPublic"] && [JSON[@"isPublic"] isKindOfClass:NSNumber.class]) {
            self.isPublic = JSON[@"isPublic"];
        }
        if (JSON[@"roles"] && [JSON[@"roles"] isKindOfClass:NSDictionary.class]) {
            self.roles = [[CMPRoles alloc] initWithJSON:JSON[@"roles"]];
        }
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSArray.class]) {
            NSMutableArray<CMPConversationParticipant *> *participants = [NSMutableArray new];
            NSArray<NSDictionary *> *objects = JSON[@"participants"];
            [objects enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [participants addObject:[[CMPConversationParticipant alloc] initWithJSON:obj]];
            }];
            self.participants = participants;
        }
    }
    
    return self;
}

@end

#pragma mark - Update

@implementation CMPConversationEventUpdate

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationEventUpdatePayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
}

@end

@implementation CMPConversationEventUpdatePayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];

    if (self) {
        if (JSON[@"id"] && [JSON[@"id"] isKindOfClass:NSString.class]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"name"] && [JSON[@"name"] isKindOfClass:NSString.class]) {
            self.name = JSON[@"name"];
        }
        if (JSON[@"isPublic"] && [JSON[@"isPublic"] isKindOfClass:NSNumber.class]) {
            self.isPublic = JSON[@"isPublic"];
        }
        if (JSON[@"roles"] && [JSON[@"roles"] isKindOfClass:NSDictionary.class]) {
            self.roles = [[CMPRoles alloc] initWithJSON:JSON[@"roles"]];
        }
        if (JSON[@"description"] && [JSON[@"description"] isKindOfClass:NSString.class]) {
            self.eventDescription = JSON[@"description"];
        }
    }
    
    return self;
}

@end

#pragma mark - Delete

@implementation CMPConversationEventDelete

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationEventDeletePayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
}

@end

@implementation CMPConversationEventDeletePayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"date"] && [JSON[@"date"] isKindOfClass:NSString.class]) {
            self.date = [(NSString *)JSON[@"date"] asDate];
        }
    }
    
    return self;
}

@end

#pragma mark - Undelete

@implementation CMPConversationEventUndelete

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationEventUndeletePayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
}

@end

@implementation CMPConversationEventUndeletePayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];

    if (self) {
        if (JSON[@"id"] && [JSON[@"id"] isKindOfClass:NSString.class]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"name"] && [JSON[@"name"] isKindOfClass:NSString.class]) {
            self.name = JSON[@"name"];
        }
        if (JSON[@"isPublic"] && [JSON[@"isPublic"] isKindOfClass:NSNumber.class]) {
            self.isPublic = JSON[@"isPublic"];
        }
        if (JSON[@"roles"] && [JSON[@"roles"] isKindOfClass:NSDictionary.class]) {
            self.roles = [[CMPRoles alloc] initWithJSON:JSON[@"roles"]];
        }
        if (JSON[@"description"] && [JSON[@"description"] isKindOfClass:NSString.class]) {
            self.eventDescription = JSON[@"description"];
        }
    }
    
    return self;
}

@end

#pragma mark - ParticipantAdded

@implementation CMPConversationEventParticipantAdded

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationEventParticipantAddedPayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
}

@end

@implementation CMPConversationEventParticipantAddedPayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];

    if (self) {
        if (JSON[@"apiSpaceId"] && [JSON[@"apiSpaceId"] isKindOfClass:NSString.class]) {
            self.apiSpaceID = JSON[@"apiSpaceId"];
        }
        if (JSON[@"profileId"] && [JSON[@"profileId"] isKindOfClass:NSString.class]) {
            self.profileID = JSON[@"profileId"];
        }
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
        if (JSON[@"role"] && [JSON[@"role"] isKindOfClass:NSString.class]) {
            self.role = JSON[@"role"];
        }
    }
    
    return self;
}

@end

#pragma mark - ParticipantRemoved

@implementation CMPConversationEventParticipantRemoved

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationEventParticipantRemovedPayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
}

@end

@implementation CMPConversationEventParticipantRemovedPayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"apiSpaceId"] && [JSON[@"apiSpaceId"] isKindOfClass:NSString.class]) {
            self.apiSpaceID = JSON[@"apiSpaceId"];
        }
        if (JSON[@"profileId"] && [JSON[@"profileId"] isKindOfClass:NSString.class]) {
            self.profileID = JSON[@"profileId"];
        }
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
    }
    
    return self;
}

@end

#pragma mark - ParticipantUpdated

@implementation CMPConversationEventParticipantUpdated

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationEventParticipantUpdatedPayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
}

@end

@implementation CMPConversationEventParticipantUpdatedPayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"apiSpaceId"] && [JSON[@"apiSpaceId"] isKindOfClass:NSString.class]) {
            self.apiSpaceID = JSON[@"apiSpaceId"];
        }
        if (JSON[@"profileId"] && [JSON[@"profileId"] isKindOfClass:NSString.class]) {
            self.profileID = JSON[@"profileId"];
        }
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
        if (JSON[@"role"] && [JSON[@"role"] isKindOfClass:NSString.class]) {
            self.role = JSON[@"role"];
        }
    }
    
    return self;
}

@end

#pragma mark - ParticipantTyping

@implementation CMPParticipantTypingEvent

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];

    if (self) {
        if (JSON[@"accountId"] && [JSON[@"accountId"] isKindOfClass:NSDictionary.class]) {
            self.accountID = JSON[@"accountId"];
        }
        if (JSON[@"publishedOn"] && [JSON[@"publishedOn"] isKindOfClass:NSDictionary.class]) {
            self.publishedOn = JSON[@"publishedOn"];
        }
    }
    
    return self;
}

@end

#pragma mark - ParticipantTypingOn

@implementation CMPConversationEventParticipantTyping

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationEventParticipantTypingPayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
}

@end

@implementation CMPConversationEventParticipantTypingPayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"profileId"] && [JSON[@"profileId"] isKindOfClass:NSString.class]) {
            self.profileID = JSON[@"profileId"];
        }
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
    }
    
    return self;
}

@end

#pragma mark - ParticipantTypingOff

@implementation CMPConversationEventParticipantTypingOff

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationEventParticipantTypingOffPayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
}

@end

@implementation CMPConversationEventParticipantTypingOffPayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"profileId"] && [JSON[@"profileId"] isKindOfClass:NSString.class]) {
            self.profileID = JSON[@"profileId"];
        }
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
    }
    
    return self;
}

@end

//extension Event {
//    public enum Conversation {
//    case create(Create)
//    case delete(Delete)
//    case participantAdded(ParticipantAdded)
//    case participantRemoved(ParticipantRemoved)
//    case participantUpdated(ParticipantUpdated)
//    case undelete(Undelete)
//    case update(Update)
//    case participantTyping(ParticipantTyping)
//    case participantTypingOff(ParticipantTypingOff)
//    }
//}
//
//extension Event.Conversation {
//
//    public struct Create: Codable, Hashable {
//        public var id: String?
//        public var apiSpaceId: String?
//        public var conversationId: String?
//        public var conversationEventID: Int?
//        public var name: EventType?
//        public var context: EventContext?
//        public var payload: Payload?
//
//        public init(id: String?,
//                    apiSpaceId: String?,
//                    conversationId: String?,
//                    conversationEventID: Int?,
//                    name: EventType?,
//                    context: EventContext?,
//                    payload: Payload?) {
//
//            self.id = id
//            self.apiSpaceId = apiSpaceId
//            self.conversationId = conversationId
//            self.conversationEventID = conversationEventID
//            self.name = name
//            self.context = context
//            self.payload = payload
//        }
//
//        private enum CodingKeys: String, CodingKey {
//        case id = "eventId"
//        case apiSpaceId = "apiSpaceId"
//        case conversationId = "conversationId"
//        case conversationEventID = "conversationEventId"
//        case name = "name"
//        case context = "context"
//        case payload = "payload"
//            }
//
//            public static func == (lhs: Create, rhs: Create) -> Bool {
//                return (lhs.id == rhs.id
//                        && lhs.apiSpaceId == rhs.apiSpaceId
//                        && lhs.conversationId == rhs.conversationId
//                        && lhs.conversationEventID == rhs.conversationEventID
//                        && lhs.name == rhs.name
//                        && lhs.context == rhs.context
//                        && lhs.payload == rhs.payload)
//            }
//
//            public var hashValue: Int {
//                return xor(self.id?.hashValue,
//                           self.apiSpaceId?.hashValue,
//                           self.conversationId?.hashValue,
//                           self.conversationEventID?.hashValue,
//                           self.name?.hashValue,
//                           self.context?.hashValue,
//                           self.payload?.hashValue)
//            }
//            }
//
//            public struct Delete: Codable, Hashable {
//                public var id: String?
//                public var apiSpaceId: String?
//                public var conversationId: String?
//                public var conversationEventID: Int?
//                public var name: EventType?
//                public var context: EventContext?
//                public var payload: Payload?
//
//                public init(id: String?,
//                            apiSpaceId: String?,
//                            conversationId: String?,
//                            conversationEventID: Int?,
//                            name: EventType?,
//                            context: EventContext?,
//                            payload: Payload?) {
//
//                    self.id = id
//                    self.apiSpaceId = apiSpaceId
//                    self.conversationId = conversationId
//                    self.conversationEventID = conversationEventID
//                    self.name = name
//                    self.context = context
//                    self.payload = payload
//                }
//
//                private enum CodingKeys: String, CodingKey {
//                case id = "eventId"
//                case apiSpaceId = "apiSpaceId"
//                case conversationId = "conversationId"
//                case conversationEventID = "conversationEventId"
//                case name = "name"
//                case context = "context"
//                case payload = "payload"
//                }
//
//                public static func == (lhs: Delete, rhs: Delete) -> Bool {
//                    return (lhs.id == rhs.id
//                            && lhs.apiSpaceId == rhs.apiSpaceId
//                            && lhs.conversationId == rhs.conversationId
//                            && lhs.conversationEventID == rhs.conversationEventID
//                            && lhs.name == rhs.name
//                            && lhs.context == rhs.context
//                            && lhs.payload == rhs.payload)
//                }
//
//                public var hashValue: Int {
//                    return xor(self.id?.hashValue,
//                               self.apiSpaceId?.hashValue,
//                               self.conversationId?.hashValue,
//                               self.conversationEventID?.hashValue,
//                               self.name?.hashValue,
//                               self.context?.hashValue,
//                               self.payload?.hashValue)
//                }
//            }
//
//            public struct ParticipantAdded: Codable, Hashable {
//                public var id: String?
//                public var apiSpaceId: String?
//                public var conversationId: String?
//                public var conversationEventID: Int?
//                public var name: EventType?
//                public var context: EventContext?
//                public var payload: Payload?
//
//                public init(id: String?,
//                            apiSpaceId: String?,
//                            conversationId: String?,
//                            conversationEventID: Int?,
//                            name: EventType?,
//                            context: EventContext?,
//                            payload: Payload?) {
//
//                    self.id = id
//                    self.apiSpaceId = apiSpaceId
//                    self.conversationId = conversationId
//                    self.conversationEventID = conversationEventID
//                    self.name = name
//                    self.context = context
//                    self.payload = payload
//                }
//
//                private enum CodingKeys: String, CodingKey {
//                case id = "eventId"
//                case apiSpaceId = "apiSpaceId"
//                case conversationId = "conversationId"
//                case conversationEventID = "conversationEventId"
//                case name = "name"
//                case context = "context"
//                case payload = "payload"
//                }
//
//                public static func == (lhs: ParticipantAdded, rhs: ParticipantAdded) -> Bool {
//                    return (lhs.id == rhs.id
//                            && lhs.apiSpaceId == rhs.apiSpaceId
//                            && lhs.conversationId == rhs.conversationId
//                            && lhs.conversationEventID == rhs.conversationEventID
//                            && lhs.name == rhs.name
//                            && lhs.context == rhs.context
//                            && lhs.payload == rhs.payload)
//                }
//
//                public var hashValue: Int {
//                    return xor(self.id?.hashValue,
//                               self.apiSpaceId?.hashValue,
//                               self.conversationId?.hashValue,
//                               self.conversationEventID?.hashValue,
//                               self.name?.hashValue,
//                               self.context?.hashValue,
//                               self.payload?.hashValue)
//                }
//            }
//
//            public struct ParticipantRemoved: Codable, Hashable {
//                public var id: String?
//                public var apiSpaceId: String?
//                public var conversationId: String?
//                public var conversationEventID: Int?
//                public var name: EventType?
//                public var context: EventContext?
//                public var payload: Payload?
//
//                public init(id: String?,
//                            apiSpaceId: String?,
//                            conversationId: String?,
//                            conversationEventID: Int?,
//                            name: EventType?,
//                            context: EventContext?,
//                            payload: Payload?) {
//
//                    self.id = id
//                    self.apiSpaceId = apiSpaceId
//                    self.conversationId = conversationId
//                    self.conversationEventID = conversationEventID
//                    self.name = name
//                    self.context = context
//                    self.payload = payload
//                }
//
//                private enum CodingKeys: String, CodingKey {
//                case id = "eventId"
//                case apiSpaceId = "apiSpaceId"
//                case conversationId = "conversationId"
//                case conversationEventID = "conversationEventId"
//                case name = "name"
//                case context = "context"
//                case payload = "payload"
//                }
//
//                public static func == (lhs: ParticipantRemoved, rhs: ParticipantRemoved) -> Bool {
//                    return (lhs.id == rhs.id
//                            && lhs.apiSpaceId == rhs.apiSpaceId
//                            && lhs.conversationId == rhs.conversationId
//                            && lhs.conversationEventID == rhs.conversationEventID
//                            && lhs.name == rhs.name
//                            && lhs.context == rhs.context
//                            && lhs.payload == rhs.payload)
//                }
//
//                public var hashValue: Int {
//                    return xor(self.id?.hashValue,
//                               self.apiSpaceId?.hashValue,
//                               self.conversationId?.hashValue,
//                               self.conversationEventID?.hashValue,
//                               self.name?.hashValue,
//                               self.context?.hashValue,
//                               self.payload?.hashValue)
//                }
//            }
//
//            public struct ParticipantUpdated: Codable, Hashable {
//                public var id: String?
//                public var apiSpaceId: String?
//                public var conversationId: String?
//                public var conversationEventID: Int?
//                public var name: EventType?
//                public var context: EventContext?
//                public var payload: Payload?
//
//                public init(id: String?,
//                            apiSpaceId: String?,
//                            conversationId: String?,
//                            conversationEventID: Int?,
//                            name: EventType?,
//                            context: EventContext?,
//                            payload: Payload?) {
//
//                    self.id = id
//                    self.apiSpaceId = apiSpaceId
//                    self.conversationId = conversationId
//                    self.conversationEventID = conversationEventID
//                    self.name = name
//                    self.context = context
//                    self.payload = payload
//                }
//
//                private enum CodingKeys: String, CodingKey {
//                case id = "eventId"
//                case apiSpaceId = "apiSpaceId"
//                case conversationId = "conversationId"
//                case conversationEventID = "conversationEventId"
//                case name = "name"
//                case context = "context"
//                case payload = "payload"
//                }
//
//                public static func == (lhs: ParticipantUpdated, rhs: ParticipantUpdated) -> Bool {
//                    return (lhs.id == rhs.id
//                            && lhs.apiSpaceId == rhs.apiSpaceId
//                            && lhs.conversationId == rhs.conversationId
//                            && lhs.conversationEventID == rhs.conversationEventID
//                            && lhs.name == rhs.name
//                            && lhs.context == rhs.context
//                            && lhs.payload == rhs.payload)
//                }
//
//                public var hashValue: Int {
//                    return xor(self.id?.hashValue,
//                               self.apiSpaceId?.hashValue,
//                               self.conversationId?.hashValue,
//                               self.conversationEventID?.hashValue,
//                               self.name?.hashValue,
//                               self.context?.hashValue,
//                               self.payload?.hashValue)
//                }
//            }
//
//            public struct Undelete: Codable, Hashable {
//                public var id: String?
//                public var apiSpaceId: String?
//                public var conversationId: String?
//                public var conversationEventID: Int?
//                public var name: EventType?
//                public var context: EventContext?
//                public var payload: Payload?
//
//                public init(id: String?,
//                            apiSpaceId: String?,
//                            conversationId: String?,
//                            conversationEventID: Int?,
//                            name: EventType?,
//                            context: EventContext?,
//                            payload: Payload?) {
//
//                    self.id = id
//                    self.apiSpaceId = apiSpaceId
//                    self.conversationId = conversationId
//                    self.conversationEventID = conversationEventID
//                    self.name = name
//                    self.context = context
//                    self.payload = payload
//                }
//
//                private enum CodingKeys: String, CodingKey {
//                case id = "eventId"
//                case apiSpaceId = "apiSpaceId"
//                case conversationId = "conversationId"
//                case conversationEventID = "conversationEventId"
//                case name = "name"
//                case context = "context"
//                case payload = "payload"
//                }
//
//                public static func == (lhs: Undelete, rhs: Undelete) -> Bool {
//                    return (lhs.id == rhs.id
//                            && lhs.apiSpaceId == rhs.apiSpaceId
//                            && lhs.conversationId == rhs.conversationId
//                            && lhs.conversationEventID == rhs.conversationEventID
//                            && lhs.name == rhs.name
//                            && lhs.context == rhs.context
//                            && lhs.payload == rhs.payload)
//                }
//
//                public var hashValue: Int {
//                    return xor(self.id?.hashValue,
//                               self.apiSpaceId?.hashValue,
//                               self.conversationId?.hashValue,
//                               self.conversationEventID?.hashValue,
//                               self.name?.hashValue,
//                               self.context?.hashValue,
//                               self.payload?.hashValue)
//                }
//            }
//
//            public struct Update: Codable, Hashable {
//                public var id: String?
//                public var apiSpaceId: String?
//                public var conversationId: String?
//                public var conversationEventID: Int?
//                public var name: EventType?
//                public var context: EventContext?
//                public var payload: Payload?
//
//                public init(id: String?,
//                            apiSpaceId: String?,
//                            conversationId: String?,
//                            conversationEventID: Int?,
//                            name: EventType?,
//                            context: EventContext?,
//                            payload: Payload?) {
//
//                    self.id = id
//                    self.apiSpaceId = apiSpaceId
//                    self.conversationId = conversationId
//                    self.conversationEventID = conversationEventID
//                    self.name = name
//                    self.context = context
//                    self.payload = payload
//                }
//
//                private enum CodingKeys: String, CodingKey {
//                case id = "eventId"
//                case apiSpaceId = "apiSpaceId"
//                case conversationId = "conversationId"
//                case conversationEventID = "conversationEventId"
//                case name = "name"
//                case context = "context"
//                case payload = "payload"
//                }
//
//                public static func == (lhs: Update, rhs: Update) -> Bool {
//                    return (lhs.id == rhs.id
//                            && lhs.apiSpaceId == rhs.apiSpaceId
//                            && lhs.conversationId == rhs.conversationId
//                            && lhs.conversationEventID == rhs.conversationEventID
//                            && lhs.name == rhs.name
//                            && lhs.context == rhs.context
//                            && lhs.payload == rhs.payload)
//                }
//
//                public var hashValue: Int {
//                    return xor(self.id?.hashValue,
//                               self.apiSpaceId?.hashValue,
//                               self.conversationId?.hashValue,
//                               self.conversationEventID?.hashValue,
//                               self.name?.hashValue,
//                               self.context?.hashValue,
//                               self.payload?.hashValue)
//                }
//            }
//
//            public struct ParticipantTyping: Codable, Hashable {
//                public var id: String?
//                public var apiSpaceId: String?
//                public var accountId: String?
//                public var publishedOn: Date?
//                public var name: EventType?
//                public var context: EventContext?
//                public var payload: Payload?
//
//                private enum CodingKeys: String, CodingKey {
//                case id = "eventId"
//                case apiSpaceId = "apiSpaceId"
//                case accountId = "accountId"
//                case publishedOn = "publishedOn"
//                case name = "name"
//                case context = "context"
//                case payload = "payload"
//                }
//
//                public static func == (lhs: ParticipantTyping, rhs: ParticipantTyping) -> Bool {
//                    return (lhs.id == rhs.id
//                            && lhs.apiSpaceId == rhs.apiSpaceId
//                            && lhs.name == rhs.name
//                            && lhs.context == rhs.context
//                            && lhs.payload == rhs.payload)
//                }
//
//                public var hashValue: Int {
//                    return xor(self.id?.hashValue,
//                               self.apiSpaceId?.hashValue,
//                               self.name?.hashValue,
//                               self.context?.hashValue,
//                               self.payload?.hashValue)
//                }
//            }
//
//            public struct ParticipantTypingOff: Codable, Hashable {
//                public var id: String?
//                public var apiSpaceId: String?
//                public var accountId: String?
//                public var publishedOn: Date?
//                public var name: EventType?
//                public var context: EventContext?
//                public var payload: Payload?
//
//                private enum CodingKeys: String, CodingKey {
//                case id = "eventId"
//                case apiSpaceId = "apiSpaceId"
//                case accountId = "accountId"
//                case publishedOn = "publishedOn"
//                case name = "name"
//                case context = "context"
//                case payload = "payload"
//                }
//
//                public static func == (lhs: ParticipantTypingOff, rhs: ParticipantTypingOff) -> Bool {
//                    return (lhs.id == rhs.id
//                            && lhs.apiSpaceId == rhs.apiSpaceId
//                            && lhs.name == rhs.name
//                            && lhs.context == rhs.context
//                            && lhs.payload == rhs.payload)
//                }
//
//                public var hashValue: Int {
//                    return xor(self.id?.hashValue,
//                               self.apiSpaceId?.hashValue,
//                               self.name?.hashValue,
//                               self.context?.hashValue,
//                               self.payload?.hashValue)
//                }
//            }
//            }
//
//            extension Event.Conversation.Create {
//                public struct Payload: Codable, Hashable {
//                    public var id: String?
//                    public var name: String?
//                    public var roles: Roles?
//                    public var isPublic: Bool?
//                    public var participants: [ConversationParticipant]?
//
//                    public init(id: String?,
//                                name: String?,
//                                roles: Roles?,
//                                isPublic: Bool?,
//                                participants: [ConversationParticipant]?) {
//
//                        self.id = id
//                        self.name = name
//                        self.roles = roles
//                        self.isPublic = isPublic
//                        self.participants = participants
//                    }
//
//                    private enum CodingKeys: String, CodingKey {
//                    case id = "id"
//                    case name = "name"
//                    case roles = "roles"
//                    case isPublic = "isPublic"
//                    case participants = "participants"
//                    }
//
//                    public var hashValue: Int {
//                        return xor(self.id?.hashValue,
//                                   self.name?.hashValue,
//                                   self.roles?.hashValue,
//                                   self.isPublic?.hashValue,
//                                   self.participants?.hashValue)
//                    }
//
//                    public static func == (lhs: Payload, rhs: Payload) -> Bool {
//                        return (lhs.id == rhs.id
//                                && lhs.name == rhs.name
//                                && lhs.roles == rhs.roles
//                                && lhs.isPublic == rhs.isPublic
//                                && lhs.participants == rhs.participants)
//                    }
//                }
//            }
//
//            extension Event.Conversation.Delete {
//                public struct Payload: Codable, Hashable {
//                    public var date: Date?
//
//                    public init(date: Date?) {
//                        self.date = date
//                    }
//
//                    private enum CodingKeys: String, CodingKey {
//                    case date = "date"
//                    }
//
//                    public var hashValue: Int {
//                        return self.date?.hashValue ?? 0
//                    }
//
//                    public static func == (lhs: Payload, rhs: Payload) -> Bool {
//                        return lhs.date == rhs.date
//                    }
//                }
//            }
//
//            extension Event.Conversation.ParticipantAdded {
//                public struct Payload: Codable, Hashable {
//                    public var profileId: String?
//                    public var role: String?
//                    public var conversationId: String?
//                    public var apiSpaceId: String?
//
//                    public init(profileId: String?, role: String?, conversationId: String?, apiSpaceId: String?) {
//                        self.profileId = profileId
//                        self.role = role
//                        self.conversationId = conversationId
//                        self.apiSpaceId = apiSpaceId
//                    }
//
//                    private enum CodingKeys: String, CodingKey {
//                    case profileId = "profileId"
//                    case role = "role"
//                    case apiSpaceId = "apiSpaceId"
//                    case conversationId = "conversationId"
//                    }
//
//                    public var hashValue: Int {
//                        return xor(self.profileId?.hashValue,
//                                   self.role?.hashValue,
//                                   self.conversationId?.hashValue,
//                                   self.apiSpaceId?.hashValue)
//                    }
//
//                    public static func == (lhs: Payload, rhs: Payload) -> Bool {
//                        return (lhs.profileId == rhs.profileId
//                                && lhs.role == rhs.role
//                                && lhs.conversationId == rhs.conversationId
//                                && lhs.apiSpaceId == rhs.apiSpaceId)
//                    }
//                }
//            }
//
//            extension Event.Conversation.ParticipantRemoved {
//                public struct Payload: Codable, Hashable {
//                    public var profileId: String?
//                    public var conversationId: String?
//                    public var apiSpaceId: String?
//
//                    public init(profileId: String?, conversationId: String?, apiSpaceId: String?) {
//                        self.profileId = profileId
//                        self.conversationId = conversationId
//                        self.apiSpaceId = apiSpaceId
//                    }
//
//                    private enum CodingKeys: String, CodingKey {
//                    case profileId = "profileId"
//                    case apiSpaceId = "apiSpaceId"
//                    case conversationId = "conversationId"
//                    }
//
//                    public var hashValue: Int {
//                        return xor(self.profileId?.hashValue,
//                                   self.conversationId?.hashValue,
//                                   self.apiSpaceId?.hashValue)
//                    }
//
//                    public static func == (lhs: Payload, rhs: Payload) -> Bool {
//                        return (lhs.profileId == rhs.profileId
//                                && lhs.conversationId == rhs.conversationId
//                                && lhs.apiSpaceId == rhs.apiSpaceId)
//                    }
//                }
//            }
//
//            extension Event.Conversation.ParticipantUpdated {
//                public struct Payload: Codable, Hashable {
//                    public var profileId: String?
//                    public var role: String?
//                    public var conversationId: String?
//                    public var apiSpaceId: String?
//
//                    public init(profileId: String?, role: String?, conversationId: String?, apiSpaceId: String?) {
//                        self.profileId = profileId
//                        self.role = role
//                        self.conversationId = conversationId
//                        self.apiSpaceId = apiSpaceId
//                    }
//
//                    private enum CodingKeys: String, CodingKey {
//                    case profileId = "profileId"
//                    case apiSpaceId = "apiSpaceId"
//                    case conversationId = "conversationId"
//                    case role = "role"
//                    }
//
//                    public var hashValue: Int {
//                        return xor(self.profileId?.hashValue,
//                                   self.role?.hashValue,
//                                   self.conversationId?.hashValue,
//                                   self.apiSpaceId?.hashValue)
//                    }
//
//                    public static func == (lhs: Payload, rhs: Payload) -> Bool {
//                        return (lhs.profileId == rhs.profileId
//                                && lhs.role == rhs.role
//                                && lhs.conversationId == rhs.conversationId
//                                && lhs.apiSpaceId == rhs.apiSpaceId)
//                    }
//                }
//            }
//
//            extension Event.Conversation.Undelete {
//                public struct Payload: Codable, Hashable {
//                    public var id: String?
//                    public var name: String?
//                    public var description: String?
//                    public var roles: Roles?
//                    public var isPublic: Bool?
//
//                    public init(id: String?, name: String?, description: String?, roles: Roles?, isPublic: Bool?) {
//                        self.id = id
//                        self.name = name
//                        self.description = description
//                        self.roles = roles
//                        self.isPublic = isPublic
//                    }
//
//                    private enum CodingKeys: String, CodingKey {
//                    case id = "id"
//                    case name = "name"
//                    case description = "description"
//                    case roles = "roles"
//                    case isPublic = "isPublic"
//                    }
//
//                    public var hashValue: Int {
//                        return xor(self.id?.hashValue,
//                                   self.name?.hashValue,
//                                   self.description?.hashValue,
//                                   self.roles?.hashValue,
//                                   self.isPublic?.hashValue)
//                    }
//
//                    public static func == (lhs: Payload, rhs: Payload) -> Bool {
//                        return (lhs.id == rhs.id
//                                && lhs.name == rhs.name
//                                && lhs.description == rhs.description
//                                && lhs.roles == rhs.roles
//                                && lhs.isPublic == rhs.isPublic)
//                    }
//                }
//            }
//
//            extension Event.Conversation.Update {
//                public struct Payload: Codable, Hashable {
//                    public var id: String?
//                    public var name: String?
//                    public var description: String?
//                    public var roles: Roles?
//
//                    public init(id: String?, name: String?, description: String?, roles: Roles?) {
//                        self.id = id
//                        self.name = name
//                        self.description = description
//                        self.roles = roles
//                    }
//
//                    private enum CodingKeys: String, CodingKey {
//                    case id = "id"
//                    case name = "name"
//                    case description = "description"
//                    case roles = "roles"
//                    }
//
//                    public var hashValue: Int {
//                        return xor(self.id?.hashValue,
//                                   self.name?.hashValue,
//                                   self.description?.hashValue,
//                                   self.roles?.hashValue)
//                    }
//
//                    public static func == (lhs: Payload, rhs: Payload) -> Bool {
//                        return (lhs.id == rhs.id
//                                && lhs.name == rhs.name
//                                && lhs.description == rhs.description
//                                && lhs.roles == rhs.roles)
//                    }
//                }
//            }
//
//            extension Event.Conversation: Equatable, Hashable {
//                public static func == (lhs: Event.Conversation, rhs: Event.Conversation) -> Bool {
//                    switch (lhs, rhs) {
//                        case (let .create(lhsEvent), let .create(rhsEvent)):
//                            return lhsEvent == rhsEvent
//                        case (let .delete(lhsEvent), let .delete(rhsEvent)):
//                            return lhsEvent == rhsEvent
//                        case (let .participantAdded(lhsEvent), let .participantAdded(rhsEvent)):
//                            return lhsEvent == rhsEvent
//                        case (let .participantRemoved(lhsEvent), let .participantRemoved(rhsEvent)):
//                            return lhsEvent == rhsEvent
//                        case (let .participantUpdated(lhsEvent), let .participantUpdated(rhsEvent)):
//                            return lhsEvent == rhsEvent
//                        case (let .undelete(lhsEvent), let .undelete(rhsEvent)):
//                            return lhsEvent == rhsEvent
//                        case (let .update(lhsEvent), let .update(rhsEvent)):
//                            return lhsEvent == rhsEvent
//                        default:
//                            return false
//                    }
//                }
//
//                public var hashValue: Int {
//                    switch self {
//                    case .create(let value): return value.hashValue
//                    case .delete(let value): return value.hashValue
//                    case .participantAdded(let value): return value.hashValue
//                    case .participantRemoved(let value): return value.hashValue
//                    case .participantUpdated(let value): return value.hashValue
//                    case .undelete(let value): return value.hashValue
//                    case .update(let value): return value.hashValue
//                    case .participantTyping(let value): return value.hashValue
//                    case .participantTypingOff(let value): return value.hashValue
//
//                    }
//                }
//            }
//
//            extension Event.Conversation.ParticipantTyping {
//                public struct Payload: Codable, Hashable {
//                    public var profileId: String?
//                    public var conversationId: String?
//
//                    public init(profileId: String?, conversationId: String?) {
//                        self.profileId = profileId
//                        self.conversationId = conversationId
//                    }
//
//                    private enum CodingKeys: String, CodingKey {
//                    case profileId = "profileId"
//                    case conversationId = "conversationId"
//                    }
//
//                    public var hashValue: Int {
//                        return xor(self.profileId?.hashValue,
//                                   self.conversationId?.hashValue)
//                    }
//
//                    public static func == (lhs: Payload, rhs: Payload) -> Bool {
//                        return (lhs.profileId == rhs.profileId
//                                && lhs.conversationId == rhs.conversationId)
//                    }
//                }
//            }
//
//            extension Event.Conversation.ParticipantTypingOff {
//                public struct Payload: Codable, Hashable {
//                    public var profileId: String?
//                    public var conversationId: String?
//
//                    public init(profileId: String?, conversationId: String?) {
//                        self.profileId = profileId
//                        self.conversationId = conversationId
//                    }
//
//                    private enum CodingKeys: String, CodingKey {
//                    case profileId = "profileId"
//                    case conversationId = "conversationId"
//                    }
//
//                    public var hashValue: Int {
//                        return xor(self.profileId?.hashValue,
//                                   self.conversationId?.hashValue)
//                    }
//
//                    public static func == (lhs: Payload, rhs: Payload) -> Bool {
//                        return (lhs.profileId == rhs.profileId
//                                && lhs.conversationId == rhs.conversationId)
//                    }
//                }
//            }
