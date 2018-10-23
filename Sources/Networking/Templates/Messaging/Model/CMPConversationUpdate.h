//
//  CMPConversationUpdate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRoles.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ConversationUpdate)
@interface CMPConversationUpdate : NSObject <CMPJSONEncoding>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSString *conversationDescription;
@property (nonatomic, strong, nullable) CMPRoles *roles;
@property (nonatomic, strong, nullable) NSNumber *isPublic;

- (instancetype)initWithID:(nullable NSString *)id name:(nullable NSString *)name description:(nullable NSString*)description roles:(nullable CMPRoles *)roles isPublic:(nullable NSNumber *)isPublic;

@end

NS_ASSUME_NONNULL_END
