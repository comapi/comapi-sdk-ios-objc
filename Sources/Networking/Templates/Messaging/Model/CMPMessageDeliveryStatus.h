//
//  CMPMessageDeliveryStatus.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 26/11/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CMPMessageDeliveryStatus) {
    CMPMessageDeliveryStatusRead,
    CMPMessageDeliveryStatusDelivered
} NS_SWIFT_NAME(MessageDeliveryStatus);

@interface CMPMessageDeliveryStatusParser : NSObject

+ (NSString *)parseStatus:(CMPMessageDeliveryStatus)status;

@end

NS_ASSUME_NONNULL_END
