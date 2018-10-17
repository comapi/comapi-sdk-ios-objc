//
//  CMPConversationUpdate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPConversationUpdate.h"

@implementation CMPConversationUpdate

- (instancetype)initWithID:(NSString *)id name:(NSString *)name description:(NSString *)description roles:(CMPRoles *)roles isPublic:(BOOL *)isPublic {
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

- (nullable NSData *)encode {
    NSDictionary<NSString *, id> *dict = @{@"id" : [self.id valueOrNull],
                                           @"name" : [self.name valueOrNull],
                                           @"description" : [self.conversationDescription valueOrNull],
                                           @"roles" : [self.roles json],
                                           @"isPublic" : [NSNumber numberWithBool:*self.isPublic]};
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    if (error) {
        return nil;
    }
    return json;
}

@end
