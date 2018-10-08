//
//  CMPOrphanedEvent.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONEncoding.h"
#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPOrphanedEvent : NSObject <CMPJSONEncoding, CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSString *messageID;
@property (nonatomic, strong, nullable) NSString *eventID;
@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSString *updatedBy;
@property (nonatomic, strong, nullable) NSDate *createdOn;

- (instancetype)initWithID:(nullable NSString *)ID messageID:(nullable NSString *)messageID eventID:(nullable NSString *)eventID conversationID:(nullable NSString *)conversationID profileID:(nullable NSString *)profileID name:(NSString *)name updatedBy:(NSString *)updatedBy createdOn:(NSDate *)createdOn;

@end

NS_ASSUME_NONNULL_END
