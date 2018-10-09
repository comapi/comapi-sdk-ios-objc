//
//  CMPSendMessagesResult.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 09/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSendMessagesResult.h"

@implementation CMPSendMessagesResult

- (instancetype)initWithID:(NSString *)ID eventID:(NSNumber *)eventID {
    self = [super init];
    
    if (self) {
        self.id = ID;
        self.eventID = eventID;
    }
    
    return self;
}

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"id"] && [JSON[@"id"] isKindOfClass:NSString.class]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"eventId"] && [JSON[@"eventId"] isKindOfClass:NSNumber.class]) {
            self.eventID = JSON[@"eventId"];
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
