//
//  CMPMessageParticipant.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMessageParticipant.h"

@implementation CMPMessageParticipant

- (instancetype)initWithID:(NSString *)ID name:(NSString *)name {
    self = [super init];
    
    if (self) {
        self.id = ID;
        self.name = name;
    }
    
    return self;
}

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"name"] && [JSON[@"name"] isKindOfClass:NSString.class]) {
            self.name = JSON[@"name"];
        }
        if (JSON[@"id"] && [JSON[@"id"] isKindOfClass:NSString.class]) {
            self.id = JSON[@"id"];
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
