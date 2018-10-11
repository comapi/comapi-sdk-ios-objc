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

@interface CMPConversationMessageEventDeliveredPayload : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *messageID;
@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSDate *timestamp;

@end

@interface CMPConversationMessageEventDelivered : CMPConversationMessageEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationMessageEventDeliveredPayload *payload;

@end

#pragma mark - Read

@interface CMPConversationMessageEventReadPayload : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *messageID;
@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSDate *timestamp;

@end

@interface CMPConversationMessageEventRead : CMPConversationMessageEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationMessageEventReadPayload *payload;

@end

#pragma mark - Sent

@interface CMPConversationMessageEventSentPayload : NSObject <CMPJSONDecoding>

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

//public struct Delivered: Codable, Hashable {
//    public var id: String?
//    public var apiSpaceId: String?
//    public var conversationEventID: Int?
//    public var name: EventType?
//    public var context: EventContext?
//    public var payload: Payload?
//
//    public init(id: String?,
//                apiSpaceId: String?,
//                conversationEventID: Int?,
//                name: EventType?,
//                context: EventContext?,
//                payload: Payload?) {
//
//        self.id = id
//        self.apiSpaceId = apiSpaceId
//        self.conversationEventID = conversationEventID
//        self.name = name
//        self.context = context
//        self.payload = payload
//    }
//
//    private enum CodingKeys: String, CodingKey {
//    case id = "eventId"
//    case apiSpaceId = "apiSpaceId"
//    case conversationEventID = "conversationEventId"
//    case name = "name"
//    case context = "context"
//    case payload = "payload"
//        }
//
//        public static func == (lhs: Delivered, rhs: Delivered) -> Bool {
//            return (lhs.id == rhs.id
//                    && lhs.apiSpaceId == rhs.apiSpaceId
//                    && lhs.conversationEventID == rhs.conversationEventID
//                    && lhs.name == rhs.name
//                    && lhs.context == rhs.context
//                    && lhs.payload == rhs.payload)
//        }
//
//        public var hashValue: Int {
//            return xor(self.id?.hashValue,
//                       self.apiSpaceId?.hashValue,
//                       self.conversationEventID?.hashValue,
//                       self.name?.hashValue,
//                       self.context?.hashValue,
//                       self.payload?.hashValue)
//        }
//        }
//
//        public struct Read: Codable, Hashable {
//            public var id: String?
//            public var apiSpaceId: String?
//            public var conversationEventID: Int?
//            public var name: EventType?
//            public var context: EventContext?
//            public var payload: Payload?
//
//            public init(id: String?,
//                        apiSpaceId: String?,
//                        conversationEventID: Int?,
//                        name: EventType?,
//                        context: EventContext?,
//                        payload: Payload?) {
//
//                self.id = id
//                self.apiSpaceId = apiSpaceId
//                self.conversationEventID = conversationEventID
//                self.name = name
//                self.context = context
//                self.payload = payload
//            }
//
//            private enum CodingKeys: String, CodingKey {
//            case id = "eventId"
//            case apiSpaceId = "apiSpaceId"
//            case conversationEventID = "conversationEventId"
//            case name = "name"
//            case context = "context"
//            case payload = "payload"
//            }
//
//            public static func == (lhs: Read, rhs: Read) -> Bool {
//                return (lhs.id == rhs.id
//                        && lhs.apiSpaceId == rhs.apiSpaceId
//                        && lhs.conversationEventID == rhs.conversationEventID
//                        && lhs.name == rhs.name
//                        && lhs.context == rhs.context
//                        && lhs.payload == rhs.payload)
//            }
//
//            public var hashValue: Int {
//                return xor(self.id?.hashValue,
//                           self.apiSpaceId?.hashValue,
//                           self.conversationEventID?.hashValue,
//                           self.name?.hashValue,
//                           self.context?.hashValue,
//                           self.payload?.hashValue)
//            }
//        }
//
//        public struct Sent: Codable, Hashable {
//            public var id: String?
//            public var apiSpaceId: String?
//            public var conversationEventID: Int?
//            public var name: EventType?
//            public var context: EventContext?
//            public var payload: Payload?
//            public var publishedOn: Date?
//
//            public init(id: String?,
//                        apiSpaceId: String?,
//                        conversationEventID: Int?,
//                        name: EventType?,
//                        context: EventContext?,
//                        payload: Payload?,
//                        publishedOn: Date?) {
//
//                self.id = id
//                self.apiSpaceId = apiSpaceId
//                self.conversationEventID = conversationEventID
//                self.name = name
//                self.context = context
//                self.payload = payload
//                self.publishedOn = publishedOn
//            }
//
//            private enum CodingKeys: String, CodingKey {
//            case id = "eventId"
//            case apiSpaceId = "apiSpaceId"
//            case conversationEventID = "conversationEventId"
//            case name = "name"
//            case context = "context"
//            case payload = "payload"
//            case publishedOn = "publishedOn"
//            }
//
//            public static func == (lhs: Sent, rhs: Sent) -> Bool {
//                return (lhs.id == rhs.id
//                        && lhs.apiSpaceId == rhs.apiSpaceId
//                        && lhs.conversationEventID == rhs.conversationEventID
//                        && lhs.name == rhs.name
//                        && lhs.context == rhs.context
//                        && lhs.payload == rhs.payload
//                        && lhs.publishedOn == rhs.publishedOn)
//            }
//
//            public var hashValue: Int {
//                return xor(self.id?.hashValue,
//                           self.apiSpaceId?.hashValue,
//                           self.conversationEventID?.hashValue,
//                           self.name?.hashValue,
//                           self.context?.hashValue,
//                           self.payload?.hashValue,
//                           self.publishedOn?.hashValue)
//            }
//        }
//        }
//
//        extension Event.ConversationMessage.Delivered {
//            public struct Payload: Codable, Hashable {
//                public var messageID: String?
//                public var conversationId: String?
//                public var profileId: String?
//                public var timestamp: Date?
//
//                public init(messageID: String?, conversationId: String?, profileId: String?, timestamp: Date?) {
//                    self.messageID = messageID
//                    self.conversationId = conversationId
//                    self.profileId = profileId
//                    self.timestamp = timestamp
//                }
//
//                private enum CodingKeys: String, CodingKey {
//                case messageID = "messageId"
//                case profileId = "profileId"
//                case conversationId = "conversationId"
//                case timestamp = "timestamp"
//                }
//
//                public var hashValue: Int {
//                    return xor(self.messageID?.hashValue,
//                               self.conversationId?.hashValue,
//                               self.profileId?.hashValue,
//                               self.timestamp?.hashValue)
//                }
//
//                public static func == (lhs: Payload, rhs: Payload) -> Bool {
//                    return (lhs.messageID == rhs.messageID
//                            && lhs.conversationId == rhs.conversationId
//                            && lhs.profileId == rhs.profileId
//                            && lhs.timestamp == rhs.timestamp)
//                }
//            }
//        }
//
//        extension Event.ConversationMessage.Read {
//            public struct Payload: Codable, Hashable {
//                public var messageID: String?
//                public var conversationId: String?
//                public var profileId: String?
//                public var timestamp: Date?
//
//                public init(messageID: String?, conversationId: String?, profileId: String?, timestamp: Date?) {
//                    self.messageID = messageID
//                    self.conversationId = conversationId
//                    self.profileId = profileId
//                    self.timestamp = timestamp
//                }
//
//                private enum CodingKeys: String, CodingKey {
//                case messageID = "messageId"
//                case profileId = "profileId"
//                case conversationId = "conversationId"
//                case timestamp = "timestamp"
//                }
//
//                public var hashValue: Int {
//                    return xor(self.messageID?.hashValue,
//                               self.conversationId?.hashValue,
//                               self.profileId?.hashValue,
//                               self.timestamp?.hashValue)
//                }
//
//                public static func == (lhs: Payload, rhs: Payload) -> Bool {
//                    return (lhs.messageID == rhs.messageID
//                            && lhs.conversationId == rhs.conversationId
//                            && lhs.profileId == rhs.profileId
//                            && lhs.timestamp == rhs.timestamp)
//                }
//            }
//        }
//
//        extension Event.ConversationMessage.Sent {
//            public struct Payload: Codable, Hashable {
//                public var messageID: String?
//                public var metadata: [String : Any]?
//                public var context: MessageContext?
//                public var parts: [MessagePart]?
//                public var alert: MessageAlert?
//
//                public init(messageID: String?,
//                            metadata: [String : Any]?,
//                            context: MessageContext?,
//                            parts: [MessagePart]?,
//                            alert: MessageAlert?) {
//
//                    self.messageID = messageID
//                    self.metadata = metadata
//                    self.context = context
//                    self.parts = parts
//                    self.alert = alert
//                }
//
//                public init(from decoder: Decoder) throws {
//                    let container = try decoder.container(keyedBy: CodingKeys.self)
//                    if let messageID: String = try? container.decode(String.self, forKey: .messageID) {
//                        self.messageID = messageID
//                    }
//                    if let metadata: [String: Any] = try? container.decode([String : Any].self, forKey: .metadata) {
//                        self.metadata = metadata
//                    }
//                    if let context: MessageContext = try? container.decode(MessageContext.self, forKey: .context) {
//                        self.context = context
//                    }
//                    if let parts: [MessagePart] = try? container.decode([MessagePart].self, forKey: .parts) {
//                        self.parts = parts
//                    }
//                    if let alert: MessageAlert = try? container.decode(MessageAlert.self, forKey: .alert) {
//                        self.alert = alert
//                    }
//                }
//
//                public func encode(to encoder: Encoder) throws {
//                    var container = encoder.container(keyedBy: CodingKeys.self)
//                    if let messageID = self.messageID {
//                        try container.encode(messageID, forKey: .messageID)
//                    }
//                    if let metadata = self.metadata {
//                        try container.encode(metadata, forKey: .metadata)
//                    }
//                    if let context = self.context {
//                        try container.encode(context, forKey: .context)
//                    }
//                    if let parts = self.parts {
//                        try container.encode(parts, forKey: .parts)
//                    }
//                    if let alert = self.alert {
//                        try container.encode(alert, forKey: .alert)
//                    }
//                }
//
//                private enum CodingKeys: String, CodingKey {
//                case messageID = "messageId"
//                case metadata = "metadata"
//                case context = "context"
//                case parts = "parts"
//                case alert = "alert"
//                }
//
//                public var hashValue: Int {
//                    return xor(self.messageID?.hashValue,
//                               (self.metadata?.keys).map { Array($0).hashValue } ?? 0,
//                               self.context?.hashValue,
//                               self.parts?.hashValue,
//                               self.alert?.hashValue)
//                }
//
//                public static func == (lhs: Payload, rhs: Payload) -> Bool {
//                    return (lhs.messageID == rhs.messageID
//                            && lhs.metadata == rhs.metadata
//                            && lhs.context == rhs.context
//                            && lhs.parts == lhs.parts
//                            && lhs.alert == rhs.alert)
//                }
//            }
//        }
//
//        extension Event.ConversationMessage: Equatable, Hashable {
//            public static func == (lhs: Event.ConversationMessage, rhs: Event.ConversationMessage) -> Bool {
//                switch (lhs, rhs) {
//                    case (let .delivered(lhsEvent), let .delivered(rhsEvent)):
//                        return lhsEvent == rhsEvent
//                    case (let .read(lhsEvent), let .read(rhsEvent)):
//                        return lhsEvent == rhsEvent
//                    case (let .sent(lhsEvent), let .sent(rhsEvent)):
//                        return lhsEvent == rhsEvent
//                    default:
//                        return false
//                }
//            }
//
//            public var hashValue: Int {
//                switch self {
//                case .delivered(let value): return value.hashValue
//                case .read(let value): return value.hashValue
//                case .sent(let value): return value.hashValue
//                }
//            }
//        }
