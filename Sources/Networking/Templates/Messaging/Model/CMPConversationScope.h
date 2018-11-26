//
//  CMPConversationScope.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 26/11/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CMPConversationScope) {
    CMPConversationScopePublic,
    CMPConversationScopeParticipant
} NS_SWIFT_NAME(ConversationScope);

NS_ASSUME_NONNULL_END
