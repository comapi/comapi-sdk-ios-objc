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
