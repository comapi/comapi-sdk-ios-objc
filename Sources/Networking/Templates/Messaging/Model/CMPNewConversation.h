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
@property (nonatomic, strong, nullable) NSNumber *isPublic;

- (instancetype)initWithID:(nullable NSString *)ID name:(nullable NSString *)name description:(nullable NSString *)descirption roles:(nullable CMPRoles *)roles participants:(nullable NSArray<CMPConversationParticipant *> *)participants isPublic:(nullable NSNumber *)isPublic;

@end

NS_ASSUME_NONNULL_END
