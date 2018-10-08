//
//  CMPMessageContext.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMessageContext.h"
#import "NSString+CMPUtility.h"

@implementation CMPMessageContext

- (instancetype)initWithConversationID:(NSString *)conversationID from:(CMPMessageParticipant *)from sentBy:(NSString *)sentBy sentOn:(NSDate *)sentOn {
    self = [super init];
    
    if (self) {
        self.conversationID = conversationID;
        self.from = from;
        self.sentBy = sentBy;
        self.sentOn = sentOn;
    }
    
    return self;
}

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
        if (JSON[@"sentBy"] && [JSON[@"sentBy"] isKindOfClass:NSString.class]) {
            self.sentBy = JSON[@"sentBy"];
        }
        if (JSON[@"sentOn"] && [JSON[@"sentOn"] isKindOfClass:NSString.class]) {
            self.sentOn = [(NSString *)JSON[@"sentOn"] asDate];
        }
        if (JSON[@"from"] && [JSON[@"from"] isKindOfClass:NSDictionary.class]) {
            self.from = [[CMPMessageParticipant alloc] initWithJSON:JSON[@"from"]];
        }
    }
    
    return self;
}

- (nullable instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
}

@end
