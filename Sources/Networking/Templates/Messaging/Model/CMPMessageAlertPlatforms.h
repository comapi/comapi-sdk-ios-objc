//
//  CMPMessageAlertPlatforms.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONEncoding.h"
#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPMessageAlertPlatforms : NSObject <CMPJSONEncoding, CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *apns;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *fcm;

- (instancetype)initWithApns:(nullable NSDictionary<NSString *, id> *)apns fcm:(nullable NSDictionary<NSString *, id> *)fcm;

@end

NS_ASSUME_NONNULL_END


//public struct MessageAlertPlatforms: Codable, Hashable {
//    public var apns: [String: Any]?
//    public var fcm: [String: Any]?
//
//    public init(apns: [String: Any]?, fcm: [String: Any]?) {
//        self.apns = apns
//        self.fcm = fcm
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        if let apns = self.apns {
//            try container.encode(apns, forKey: .apns)
//        }
//        if let fcm = self.fcm {
//            try container.encode(fcm, forKey: .fcm)
//        }
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        if let apns: [String: Any] = try? container.decode([String: Any].self, forKey: .apns) {
//            self.apns = apns
//        }
//        if let fcm: [String: Any] = try? container.decode([String: Any].self, forKey: .fcm) {
//            self.fcm = fcm
//        }
//    }
//
//    private enum CodingKeys: String, CodingKey {
//    case apns = "apns"
//    case fcm = "fcm"
//        }
//
//        public var hashValue: Int {
//            let apnsHash = (self.apns?.keys).map { Array($0).hashValue } ?? 0
//            let fcmHash = (self.fcm?.keys).map { Array($0).hashValue } ?? 0
//            return apnsHash ^ fcmHash
//        }
//
//        public static func == (lhs: MessageAlertPlatforms, rhs: MessageAlertPlatforms) -> Bool {
//            return lhs.apns == rhs.apns && lhs.fcm == rhs.fcm
//        }
//    }
