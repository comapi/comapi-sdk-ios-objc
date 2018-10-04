//
//  CMPRoleAttributes.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONEncoding.h"
#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(RoleAttributes)
@interface CMPRoleAttributes : NSObject <CMPJSONEncoding, CMPJSONDecoding>

@property (nonatomic) BOOL canSend;
@property (nonatomic) BOOL canAddParticipants;
@property (nonatomic) BOOL canRemoveParticipants;

- (instancetype)initWithCanSend:(BOOL)canSend canAddParticipants:(BOOL)canAddParticipants canRemoveParticipants:(BOOL)canRemoveParticipants;

@end

NS_ASSUME_NONNULL_END
