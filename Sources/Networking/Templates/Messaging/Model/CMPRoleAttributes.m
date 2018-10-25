//
//  CMPRoleAttributes.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRoleAttributes.h"

@implementation CMPRoleAttributes

- (instancetype)initWithCanSend:(BOOL)canSend canAddParticipants:(BOOL)canAddParticipants canRemoveParticipants:(BOOL)canRemoveParticipants {
    self = [super init];
    
    if (self) {
        self.canSend = canSend;
        self.canAddParticipants = canAddParticipants;
        self.canRemoveParticipants = canRemoveParticipants;
    }
    
    return self;
}

#pragma mark - CMPJSONEncoding

- (id)json {
    return @{@"canSend" : [NSNumber numberWithBool:self.canSend],
             @"canAddParticipants" : [NSNumber numberWithBool:self.canAddParticipants],
             @"canRemoveParticipants" : [NSNumber numberWithBool:self.canRemoveParticipants]};
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
        if (JSON[@"canSend"] && [JSON[@"canSend"] isKindOfClass:NSNumber.class]) {
            self.canSend = ([(NSNumber *)JSON[@"canSend"] boolValue]);
        }
        if (JSON[@"canRemoveParticipants"] && [JSON[@"canRemoveParticipants"] isKindOfClass:NSNumber.class]) {
            self.canRemoveParticipants = ([(NSNumber *)JSON[@"canRemoveParticipants"] boolValue]);
        }
        if (JSON[@"canAddParticipants"] && [JSON[@"canAddParticipants"] isKindOfClass:NSNumber.class]) {
            self.canAddParticipants = ([(NSNumber *)JSON[@"canAddParticipants"] boolValue]);
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
    return [[CMPRoleAttributes alloc] initWithJSON:json];
}

@end
