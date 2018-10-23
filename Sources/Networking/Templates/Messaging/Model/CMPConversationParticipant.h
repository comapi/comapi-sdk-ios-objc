//
//  CMPConversationParticipant.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONEncoding.h"
#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ConversationParticipant)
@interface CMPConversationParticipant : NSObject <CMPJSONEncoding, CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSString *role;

- (instancetype)initWithID:(NSString *)ID role:(NSString *)role;

@end

NS_ASSUME_NONNULL_END
