//
//  CMPConversationParticipant.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPConversationParticipant.h"

@implementation CMPConversationParticipant

- (instancetype)initWithID:(NSString *)ID role:(NSString *)role {
    self = [super init];
    
    if (self) {
        self.id = ID;
        self.role = role;
    }
    
    return self;
}

- (instancetype)initWithJSON:(NSDictionary<NSString *, id> *)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"id"] && [JSON[@"id"] isKindOfClass:NSString.class]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"role"] && [JSON[@"role"] isKindOfClass:NSString.class]) {
            self.role = JSON[@"role"];
        }
    }
    
    return self;
}

- (id)json {
    return @{@"id" : self.id,
             @"role" : self.role};
}

- (nullable instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    NSDictionary<NSString *, id> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
}

@end


