//
//  CMPRoles.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRoles.h"

@implementation CMPRoles

- (instancetype)initWithOwnerAttributes:(CMPRoleAttributes *)ownerAttributes participantAttributes:(CMPRoleAttributes *)participantAttributes {
    self = [super init];
    
    if (self) {
        self.owner = ownerAttributes;
        self.participants = participantAttributes;
    }
    
    return self;
}

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        NSError *error = nil;
        if (JSON[@"owner"] && [JSON[@"owner"] isKindOfClass:NSDictionary.class]) {
            self.owner = [[CMPRoleAttributes alloc] decodeWithData:[NSJSONSerialization dataWithJSONObject:JSON[@"owner"] options:0 error:&error]];
        }
        if (JSON[@"participant"] && [JSON[@"participant"] isKindOfClass:NSDictionary.class]) {
            self.participants = [[CMPRoleAttributes alloc] decodeWithData:[NSJSONSerialization dataWithJSONObject:JSON[@"participant"] options:0 error:&error]];
        }
    }
    
    return self;
}

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    NSDictionary<NSString *, id> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
}

- (id)json {
    NSDictionary<NSString *, id> *ownerAttributesDict = [self.owner json];
    NSDictionary<NSString *, id> *participantsAttributesDict = [self.participants json];
    NSDictionary<NSString *, id> *dict = @{@"owner" : ownerAttributesDict,
                                           @"participant" : participantsAttributesDict};
    return dict;
}

- (nullable NSData *)encode {
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:[self json] options:0 error:&error];
    if (error) {
        return nil;
    }
    return json;
}

@end

