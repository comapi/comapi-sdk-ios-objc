//
//  CMPNewConversation.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPNewConversation.h"

@implementation CMPNewConversation

- (instancetype)initWithID:(NSString *)ID name:(NSString *)name description:(NSString *)descirption roles:(CMPRoles *)roles participants:(NSMutableArray<CMPConversationParticipant *> *)participants isPublic:(BOOL *)isPublic {
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

- (NSData *)encode {
    NSMutableArray<NSDictionary<NSString *, id> *> *participants = [NSMutableArray new];
    [self.participants enumerateObjectsUsingBlock:^(CMPConversationParticipant * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [participants addObject:[obj json]];
    }];
    NSDictionary<NSString *, id> *dict = @{@"id" : self.id,
                                           @"name" : self.name,
                                           @"description" : self.conversationDescription,
                                           @"roles" : [self.roles json],
                                           @"isPublic" : [NSNumber numberWithBool:*self.isPublic],
                                           @"participants" : participants};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
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
