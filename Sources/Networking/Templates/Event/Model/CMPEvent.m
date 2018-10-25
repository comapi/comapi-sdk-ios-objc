//
//  CMPEvent.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 03/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPEvent.h"

@implementation CMPEvent

#pragma mark - CMPJSONRepresentable

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.eventID forKey:@"eventId"];
    [dict setValue:self.apiSpaceID forKey:@"apiSpaceId"];
    [dict setValue:self.name forKey:@"name"];
    [dict setValue:[self.context json] forKey:@"context"];
    
    return dict;
}

#pragma mark - CMPJSONDecoding

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

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPEvent alloc] initWithJSON:json];
}

@end

@implementation CMPEventContext

#pragma mark - CMPJSONRepresentable

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.createdBy forKey:@"createdBy"];
    
    return dict;
}

#pragma mark - CMPJSONDecoding

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"createdBy"] && [JSON[@"createdBy"] isKindOfClass:NSString.class]) {
            self.createdBy = JSON[@"createdBy"];
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
    return [[CMPEventContext alloc] initWithJSON:json];
}

@end
