//
//  CMPConversationParticipant.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONEncoding.h"
#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ConversationParticipant)
@interface CMPConversationParticipant : NSObject <CMPJSONEncoding, CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSString *role;

- (instancetype)initWithID:(NSString *)ID role:(NSString *)role;

//public var id: String?
//public var role: String?
//
//public init(id: String?, role: String?) {
//    self.id = id
//    self.role = role
//}
//
//public init() { }
//
//private enum CodingKeys: String, CodingKey {
//case id = "id"
//case role = "role"
//}
//
//public var hashValue: Int {
//    return xor(self.id?.hashValue, self.role?.hashValue)
//}
//
//public static func == (lhs: ConversationParticipant, rhs: ConversationParticipant) -> Bool {
//    return (lhs.id == rhs.id) && (lhs.role == rhs.role)
//}

@end

NS_ASSUME_NONNULL_END
