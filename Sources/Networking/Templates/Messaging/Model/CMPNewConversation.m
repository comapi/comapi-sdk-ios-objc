//
//  CMPNewConversation.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPNewConversation.h"

@implementation CMPNewConversation

- (instancetype)initWithID:(NSString *)ID name:(NSString *)name description:(NSString *)descirption roles:(CMPRoles *)roles participants:(NSMutableArray<CMPConversationParticipant *> *)participants isPublic:(NSNumber *)isPublic {
    self = [super init];
    
    if (self) {
        self.id = ID;
        self.name = name;
        self.conversationDescription = descirption;
        self.roles = roles;
        self.participants = participants;
        self.isPublic = isPublic;
    }
    
    return self;
}

- (id)json {
    NSMutableArray<NSDictionary<NSString *, id> *> *participants = [NSMutableArray new];
    [self.participants enumerateObjectsUsingBlock:^(CMPConversationParticipant * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [participants addObject:[obj json]];
    }];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.id forKey:@"id"];
    [dict setValue:self.name forKey:@"name"];
    [dict setValue:self.conversationDescription forKey:@"description"];
    [dict setValue:[self.roles json] forKey:@"roles"];
    [dict setValue:self.isPublic forKey:@"isPublic"];
    [dict setValue:participants forKey:@"participants"];
    
    return dict;
}

- (NSData *)encode {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self json] options:0 error:&error];
    if (error) {
        return nil;
    }
    return data;
}

//public var id: String?
//public var name: String?
//public var conversationDescription: String?
//public var roles: Roles?
//public var isPublic: Bool?
//public var participants: [ConversationParticipant]?
//
//public init(id: String? = nil,
//            name: String? = nil,
//            conversationDescription: String? = nil,
//            roles: Roles? = nil,
//            isPublic: Bool? = nil,
//            participants: [ConversationParticipant]? = nil) {
//
//    self.id = id
//    self.name = name
//    self.conversationDescription = conversationDescription
//    self.roles = roles
//    self.isPublic = isPublic
//    self.participants = participants
//}
//
//private enum CodingKeys: String, CodingKey {
//case id = "id"
//case name = "name"
//case conversationDescription = "description"
//case roles = "roles"
//case isPublic = "isPublic"
//case participants = "participants"
//}

@end
