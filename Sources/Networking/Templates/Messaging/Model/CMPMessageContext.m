//
//  CMPMessageContext.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMessageContext.h"
#import "NSString+CMPUtility.h"
#import "NSDate+CMPUtility.h"

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

#pragma mark - CMPJSONRepresentable

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.conversationID forKey:@"conversationId"];
    [dict setValue:self.sentBy forKey:@"sentBy"];
    [dict setValue:[self.sentOn ISO8061String] forKey:@"sentOn"];
    [dict setValue:[self.from json] forKey:@"from"];
    
    return dict;
}

#pragma mark - CMPJSONDecoding

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

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPMessageContext alloc] initWithJSON:json];
}

@end
