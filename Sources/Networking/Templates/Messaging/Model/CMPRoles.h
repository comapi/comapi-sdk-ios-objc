//
//  CMPRoles.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRoleAttributes.h"
#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Roles)
@interface CMPRoles : NSObject <CMPJSONEncoding, CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPRoleAttributes *owner;
@property (nonatomic, strong, nullable) CMPRoleAttributes *participants;

- (instancetype)initWithOwnerAttributes:(CMPRoleAttributes *)ownerAttributes participantAttributes:(CMPRoleAttributes *)participantAttributes;

@end

//public struct Roles: Codable, Hashable {
//    public var owner: RoleAttributes?
//    public var participant: RoleAttributes?
//
//    public init(owner: RoleAttributes?, participant: RoleAttributes?) {
//        self.owner = owner
//        self.participant = participant
//    }
//
//    private enum CodingKeys: String, CodingKey {
//    case owner = "owner"
//    case participant = "participant"
//        }
//
//        public var hashValue: Int { return xor(self.owner?.hashValue, self.participant?.hashValue) }
//
//        public static func == (lhs: Roles, rhs: Roles) -> Bool {
//            return (lhs.owner == rhs.owner) && (lhs.participant == rhs.participant)
//        }
//        }

NS_ASSUME_NONNULL_END
