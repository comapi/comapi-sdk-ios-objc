//
//  CMPRoles.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRoleAttributes.h"
#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Roles)
@interface CMPRoles : NSObject <CMPJSONEncoding, CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPRoleAttributes *owner;
@property (nonatomic, strong, nullable) CMPRoleAttributes *participant;

- (instancetype)initWithOwnerAttributes:(CMPRoleAttributes *)ownerAttributes participantAttributes:(CMPRoleAttributes *)participantAttributes;

@end

NS_ASSUME_NONNULL_END
