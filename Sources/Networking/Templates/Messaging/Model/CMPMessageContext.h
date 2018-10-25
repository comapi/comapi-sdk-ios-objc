//
//  CMPMessageContext.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMessageParticipant.h"
#import "CMPJSONRepresentable.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPMessageContext : NSObject <CMPJSONDecoding, CMPJSONRepresentable>

@property (nonatomic, strong, nullable) CMPMessageParticipant *from;
@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSString *sentBy;
@property (nonatomic, strong, nullable) NSDate *sentOn;

- (instancetype)initWithConversationID:(nullable NSString *)conversationID from:(nullable CMPMessageParticipant *)from sentBy:(nullable NSString *)sentBy sentOn:(nullable NSDate *)sentOn;

@end

NS_ASSUME_NONNULL_END
