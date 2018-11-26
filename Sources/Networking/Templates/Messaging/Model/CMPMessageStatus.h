//
//  CMPMessageStatusUpdate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONEncoding.h"
#import "CMPJSONDecoding.h"
#import "CMPMessageDeliveryStatus.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MessageStatus)
@interface CMPMessageStatus : NSObject <CMPJSONDecoding, CMPJSONEncoding>

@property (nonatomic) CMPMessageDeliveryStatus status;
@property (nonatomic, strong, nullable) NSDate *timestamp;

- (instancetype)initWithStatus:(CMPMessageDeliveryStatus)status timestamp:(nullable NSDate *)timestamp;

@end

NS_ASSUME_NONNULL_END
