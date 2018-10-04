//
//  CMPNewConversation.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRoles.h"
#import "CMPConversationParticipant.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(NewConversation)
@interface CMPNewConversation : NSObject <CMPJSONEncoding>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSString *conversationDescription;
@property (nonatomic, strong, nullable) CMPRoles *roles;
@property (nonatomic, strong, nullable) NSArray<CMPConversationParticipant *> *participants;
@property (nonatomic, nullable) BOOL *isPublic;

- (instancetype)initWithID:(nullable NSString *)ID name:(nullable NSString *)name description:(nullable NSString *)descirption roles:(nullable CMPRoles *)roles participants:(nullable NSArray<CMPConversationParticipant *> *)participants isPublic:(nullable BOOL *)isPublic;
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

NS_ASSUME_NONNULL_END
