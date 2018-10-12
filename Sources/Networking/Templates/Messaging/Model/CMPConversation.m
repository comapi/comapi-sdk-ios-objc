//
//  CMPConversation.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 03/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPConversation.h"

@implementation CMPConversation

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        NSError *error = nil;
        if (JSON[@"id"] && [JSON[@"id"] isKindOfClass:NSString.class]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"name"] && [JSON[@"name"] isKindOfClass:NSString.class]) {
            self.name = JSON[@"name"];
        }
        if (JSON[@"conversationDescription"] && [JSON[@"conversationDescription"] isKindOfClass:NSString.class]) {
            self.conversationDescription = JSON[@"conversationDescription"];
        }
        if (JSON[@"roles"] && [JSON[@"roles"] isKindOfClass:NSDictionary.class]) {
            self.roles = [[CMPRoles alloc] decodeWithData:[NSJSONSerialization dataWithJSONObject:JSON[@"roles"] options:0 error:&error]];
        }
        if (JSON[@"isPublic"] && [JSON[@"isPublic"] isKindOfClass:NSNumber.class]) {
            self.isPublic = JSON[@"isPublic"];
        }
    }
    
    return self;
}

- (nullable NSData *)encode {
    NSDictionary<NSString *, id> *dict = @{@"id" : self.id,
                                           @"name" : self.name,
                                           @"description" : self.conversationDescription,
                                           @"roles" : [self.roles json],
                                           @"isPublic" : self.isPublic};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    if (error) {
        return nil;
    }
    return data;
}

- (nullable instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    NSDictionary<NSString *, id> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    return [self initWithJSON:json];
}

@end

//private enum CodingKeys: String, CodingKey {
//case id = "id"
//case name = "name"
//case conversationDescription = "description"
//case roles = "roles"
//case isPublic = "isPublic"
//case createdOn = "_createdOn"
//case updatedOn = "_updatedOn"
//case isDeleted = "_isDeleted"
//case deletedOn = "_deletedOn"
//    }
