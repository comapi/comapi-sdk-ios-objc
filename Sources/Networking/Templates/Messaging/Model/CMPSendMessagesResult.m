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

#pragma mark - CMPJSONRepresentable

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.id forKey:@"id"];
    [dict setValue:self.eventID forKey:@"eventId"];
    
    return dict;
}

#pragma mark - CMPJSONDecoding

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

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPSendMessagesResult alloc] initWithJSON:json];
}

@end
