//
//  CMPProfileEvents.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 11/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPProfileEvents.h"

@implementation CMPProfileEventUpdatePayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"name"] && [JSON[@"name"] isKindOfClass:NSString.class]) {
            self.name = JSON[@"name"];
        }
        if (JSON[@"eventId"] && [JSON[@"eventId"] isKindOfClass:NSString.class]) {
            self.eventID = JSON[@"eventId"];
        }
    }
    
    return self;
}

@end

@implementation CMPProfileEventUpdate

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPProfileEventUpdatePayload alloc] initWithJSON:JSON[@"payload"]];
        }
        if (JSON[@"profileId"] && [JSON[@"profileId"] isKindOfClass:NSString.class]) {
            self.profileID = JSON[@"profileId"];
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

//public struct Update: Codable {
//    public var id: String?
//    public var apiSpaceId: String?
//    public var profileId: String?
//    public var name: EventType?
//    public var context: EventContext?
//    public var payload: Payload?
//
//    public struct Payload: Codable, Hashable {
//
//        public var id: String?
//        public var name: String?
//
//        private enum CodingKeys: String, CodingKey {
//        case id = "eventId"
//        case name = "name"
//        }
//        public var hashValue: Int {
//            return xor(id?.hashValue, name?.hashValue)
//        }
//
//        public static func == (lhs: Payload, rhs: Payload) -> Bool {
//            return lhs.id == rhs.id && lhs.name == rhs.name
//        }
//    }
//
//    public init() { }
//
//    private enum CodingKeys: String, CodingKey {
//    case id = "eventId"
//    case apiSpaceId = "apiSpaceId"
//    case profileId = "profileId"
//    case name = "name"
//    case context = "context"
//    case payload = "payload"
//        }
