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
