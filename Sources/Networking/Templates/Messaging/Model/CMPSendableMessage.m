//
//  CMPSendableMessage.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSendableMessage.h"

@implementation CMPSendableMessage

- (instancetype)initWithMetadata:(NSDictionary<NSString *,id> *)metadata parts:(NSArray<CMPMessagePart *> *)parts alert:(CMPMessageAlert *)alert {
    self = [super init];
    
    if (self) {
        self.metadata = metadata;
        self.parts = parts;
        self.alert = alert;
    }
    
    return self;
}

- (id)json {
    NSMutableArray<NSDictionary<NSString *, id> *> *parts = [NSMutableArray new];
    [self.parts enumerateObjectsUsingBlock:^(CMPMessagePart * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parts addObject:[obj json]];
    }];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.metadata forKey:@"metadata"];
    [dict setValue:parts forKey:@"parts"];
    [dict setValue:self.alert forKey:@"alert"];

    return dict;
}

- (NSData *)encode {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self json] options:0 error:&error];
    if (error) {
        return nil;
    }
    return data;
}

@end

//public struct SendableMessage: Codable {
//    public var metadata: [String : Any]?
//    public var parts: [MessagePart]?
//    public var alert: MessageAlert?
//
//    public init(metadata: [String : Any]? = nil, parts: [MessagePart]? = nil, alert: MessageAlert? = nil) {
//        self.metadata = metadata
//        self.parts = parts
//        self.alert = alert
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        if let parts: [MessagePart] = try? container.decode([MessagePart].self, forKey: .parts) {
//            self.parts = parts
//        }
//        if let alert: MessageAlert = try? container.decode(MessageAlert.self, forKey: .alert) {
//            self.alert = alert
//        }
//        if let metadata: [String: Any] = try? container.decode([String : Any].self, forKey: .metadata) {
//            self.metadata = metadata
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        if let metadata = self.metadata {
//            try container.encode(metadata, forKey: .metadata)
//        }
//        if let parts = self.parts {
//            try container.encode(parts, forKey: .parts)
//        }
//        if let alert = self.alert {
//            try container.encode(alert, forKey: .alert)
//        }
//    }
//
//    private enum CodingKeys: String, CodingKey {
//    case metadata = "metadata"
//    case parts = "parts"
//    case alert = "alert"
//    }
//}
