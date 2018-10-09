//
//  CMPSendMessagesResult.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 09/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPSendMessagesResult : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSNumber *eventID;

- (instancetype)initWithID:(NSString *)ID eventID:(NSNumber *)eventID;

@end

NS_ASSUME_NONNULL_END

//public struct PostMessagesResult {
//    public var id: String
//    public var eventId: Int?
//
//    static func from(_ json: JSON) throws -> PostMessagesResult {
//        return try PostMessagesResult(id: json.id.unwrapped(), eventId: json.eventId)
//    }
//
//    func toJSON() -> JSON {
//        return JSON(id: self.id, eventId: self.eventId)
//    }
//}
//
//extension PostMessagesResult {
//    struct JSON: Codable {
//        var id: String?
//        var eventId: Int?
//
//        private enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case eventId = "eventId"
//        }
//    }
//}
