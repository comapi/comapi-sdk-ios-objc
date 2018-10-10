//
//  CMPEvent.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 03/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPEvent.h"

@implementation CMPEvent

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"eventId"] && [JSON[@"eventId"] isKindOfClass:NSString.class]) {
            self.eventID = JSON[@"eventId"];
        }
        if (JSON[@"apiSpaceId"] && [JSON[@"apiSpaceId"] isKindOfClass:NSString.class]) {
            self.apiSpaceID = JSON[@"apiSpaceId"];
        }
        if (JSON[@"name"] && [JSON[@"name"] isKindOfClass:NSString.class]) {
            self.name = JSON[@"name"];
        }
        if (JSON[@"context"] && [JSON[@"context"] isKindOfClass:NSDictionary.class]) {
            self.context = [[CMPEventContext alloc] initWithJSON:JSON[@"context"]];
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

@implementation CMPEventContext

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"createdBy"] && [JSON[@"createdBy"] isKindOfClass:NSString.class]) {
            self.createdBy = JSON[@"createdBy"];
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
