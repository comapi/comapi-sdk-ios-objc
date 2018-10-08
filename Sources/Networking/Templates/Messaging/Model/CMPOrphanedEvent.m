//
//  CMPOrphanedEvent.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPOrphanedEvent.h"
#import "NSString+CMPUtility.h"

@implementation CMPOrphanedEvent

- (instancetype)initWithID:(NSString *)ID messageID:(nullable NSString *)messageID eventID:(NSString *)eventID conversationID:(NSString *)conversationID profileID:(NSString *)profileID name:(NSString *)name updatedBy:(NSString *)updatedBy createdOn:(NSDate *)createdOn {
    self = [super init];
    
    if (self) {
        self.id = ID;
        self.messageID = messageID;
        self.eventID = eventID;
        self.conversationID = conversationID;
        self.profileID = profileID;
        self.name = name;
        self.updatedBy = updatedBy;
        self.createdOn = createdOn;
    }
    
    return self;
}

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"id"] && [JSON[@"id"] isKindOfClass:NSString.class]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"payload.messageId"] && [JSON[@"payload.messageId"] isKindOfClass:NSString.class]) {
            self.messageID = JSON[@"payload.messageId"];
        }
        if (JSON[@"payload.conversationId"] && [JSON[@"payload.conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"payload.conversationId"];
        }
        if (JSON[@"name"] && [JSON[@"name"] isKindOfClass:NSString.class]) {
            self.name = JSON[@"name"];
        }
        if (JSON[@"createdOn"] && [JSON[@"createdOn"] isKindOfClass:NSString.class]) {
            self.createdOn = [(NSString *)JSON[@"createdOn"] asDate];
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
    return json;
}

@end

//public struct OrphanedEvent: Codable {
    //    public var id: String?
    //    public var eventId: String?
    //    public var messageId: String?
    //    public var conversationId: String?
    //    public var profileId: String?
    //    public var name: String?
    //    public var createdOn: Date?
    //    public var updatedBy: String?
    //
    //    public init(fromDictionary json: [String: Any]){
    //
    //        if let id = json["id"] as? Int{
    //            self.id = String(id)
    //        }
    //        if let data = json["data"] as? [String: Any]{
    //            if let name = data["name"] as? String{
    //                self.name = name
    //            }
    //
    //            if let payload = data["payload"] as? [String: Any]{
    //                if let messageId = payload["messageId"] as? String{
    //                    self.messageId = messageId
    //                }
    //
    //                if let conversationId = payload["conversationId"] as? String{
    //                    self.conversationId = conversationId
    //                }
    //
    //                if let profileId = payload["profileId"] as? String{
    //                    self.profileId = profileId
    //                }
    //            }
    //        }
    //
    //    }
    //
    //    private enum CodingKeys: String, CodingKey {
    //    case id = "id"
    //    case messageId = "payload.messageId"
    //    case conversationId = "payload.conversationId"
    //    case createdOn = "createdOn"
    //    case name = "name"
    //    }
    //}
