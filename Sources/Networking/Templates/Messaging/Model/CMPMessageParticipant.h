//
//  CMPMessageParticipant.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPMessageParticipant : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSString *name;

- (instancetype)initWithID:(NSString *)ID name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

//public struct MessageParticipant: Codable, Hashable {
//    public var id: String?
//    public var name: String?
//
//    public init(id: String?, name: String?) {
//        self.id = id
//        self.name = name
//    }
//
//    private enum CodingKeys: String, CodingKey {
//    case id = "id"
//    case name = "name"
//        }
//
//        public var hashValue: Int { return xor(self.id?.hashValue, self.name?.hashValue) }
//
//        public static func == (lhs: MessageParticipant, rhs: MessageParticipant) -> Bool {
//            return (lhs.id == rhs.id
//                    && lhs.name == rhs.name)
//        }
//    }
