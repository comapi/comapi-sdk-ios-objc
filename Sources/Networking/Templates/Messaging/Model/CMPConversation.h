//
//  CMPConversation.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 03/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRoles.h"
#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Conversation)
@interface CMPConversation : NSObject <CMPJSONEncoding, CMPJSONDecoding>

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) CMPRoles *roles;
@property (nonatomic, strong, nullable) NSString *conversationDescription;
@property (nonatomic) BOOL isPublic;

//public var id: String
//public var name: String
//public var conversationDescription: String?
//public var roles: Roles
//public var isPublic: Bool
//public var createdOn: Date?
//public var updatedOn: Date?
//public var isDeleted: Bool?
//public var deletedOn: Date?
@end

NS_ASSUME_NONNULL_END
