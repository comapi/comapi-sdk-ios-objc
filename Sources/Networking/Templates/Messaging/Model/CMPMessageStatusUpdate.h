//
//  CMPMessageStatusUpdate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 09/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONEncoding.h"
#import "CMPJSONDecoding.h"
#import "CMPMessageDeliveryStatus.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MessageStatusUpdate)
@interface CMPMessageStatusUpdate : NSObject <CMPJSONDecoding, CMPJSONEncoding>

@property (nonatomic, strong, nullable) NSArray<NSString *> *messageIDs;
@property (nonatomic, strong, nullable) NSDate *timestamp;
@property (nonatomic) CMPMessageDeliveryStatus status;

- (instancetype)initWithStatus:(CMPMessageDeliveryStatus)status timestamp:(nullable NSDate *)timestamp messageIDs:(nullable NSArray<NSString *> *)messageIDs;

@end

NS_ASSUME_NONNULL_END
