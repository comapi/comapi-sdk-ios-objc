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

#pragma mark - CMPJSONEncoding

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:[self.owner json] forKey:@"owner"];
    [dict setValue:[self.participants json] forKey:@"participant"];
    
    return dict;
}

- (NSData *)encode {
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:[self json] options:0 error:&error];
    if (error) {
        return nil;
    }
    return json;
}

#pragma mark - CMPJSONDecoding

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"owner"] && [JSON[@"owner"] isKindOfClass:NSDictionary.class]) {
            self.owner = [[CMPRoleAttributes alloc] initWithJSON:JSON[@"owner"]];
        }
        if (JSON[@"participant"] && [JSON[@"participant"] isKindOfClass:NSDictionary.class]) {
            self.participants = [[CMPRoleAttributes alloc] initWithJSON:JSON[@"participant"]];
        }
    }
    
    return self;
}

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    NSDictionary<NSString *, id> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPRoles alloc] initWithJSON:json];
}



@end

