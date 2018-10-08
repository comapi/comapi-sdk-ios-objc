//
//  CMPMessageContext.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMessageParticipant.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPMessageContext : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPMessageParticipant *from;
@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSString *sentBy;
@property (nonatomic, strong, nullable) NSDate *sentOn;

- (instancetype)initWithConversationID:(nullable NSString *)conversationID from:(nullable CMPMessageParticipant *)from sentBy:(nullable NSString *)sentBy sentOn:(nullable NSDate *)sentOn;

@end

NS_ASSUME_NONNULL_END

//public struct MessageContext: Codable, Hashable {
//    public var from: MessageParticipant?
//    public var conversationId: String?
//    public var sentBy: String?
//    public var sentOn: Date?
//
//    public init(from: MessageParticipant?, conversationId: String?, sentBy: String?, sentOn: Date?) {
//        self.from = from
//        self.conversationId = conversationId
//        self.sentBy = sentBy
//        self.sentOn = sentOn
//    }
//
//    public init() { }
//
//    private enum CodingKeys: String, CodingKey {
//    case from = "from"
//    case conversationId = "conversationId"
//    case sentBy = "sentBy"
//    case sentOn = "sentOn"
//        }
//
//        public var hashValue: Int {
//            return xor(self.from?.hashValue,
//                       self.conversationId?.hashValue,
//                       self.sentBy?.hashValue,
//                       self.sentOn?.hashValue)
//        }
//
//        public static func == (lhs: MessageContext, rhs: MessageContext) -> Bool {
//            return (lhs.from == rhs.from
//                    && lhs.conversationId == rhs.conversationId
//                    && lhs.sentBy == rhs.sentBy
//                    && lhs.sentOn == rhs.sentOn)
//        }
//    }
