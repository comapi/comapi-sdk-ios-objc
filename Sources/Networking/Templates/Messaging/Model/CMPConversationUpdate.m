//
//  CMPConversationUpdate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPConversationUpdate.h"

@implementation CMPConversationUpdate

- (instancetype)initWithID:(NSString *)id name:(NSString *)name description:(NSString *)description roles:(CMPRoles *)roles isPublic:(NSNumber *)isPublic {
    self = [super init];
    
    if (self) {
        self.id = id;
        self.name = name;
        self.conversationDescription = description;
        self.roles = roles;
        self.isPublic = isPublic;
    }
    
    return self;
}

#pragma mark - CMPJSONEncoding

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.id forKey:@"id"];
    [dict setValue:self.name forKey:@"name"];
    [dict setValue:self.conversationDescription forKey:@"description"];
    [dict setValue:[self.roles json] forKey:@"roles"];
    [dict setValue:self.isPublic forKey:@"isPublic"];
    
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

@end
