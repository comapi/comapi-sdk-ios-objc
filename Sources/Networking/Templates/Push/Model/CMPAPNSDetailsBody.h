//
//  APNSDetailsBody.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 30/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAPNSDetails.h"
#import "CMPJSONEncoding.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(APNSDetailsBody)
@interface CMPAPNSDetailsBody : NSObject <CMPJSONEncoding>

@property (nonatomic, strong, nullable) CMPAPNSDetails *apns;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAPNSDetails:(CMPAPNSDetails *)apnsDetails;

@end

NS_ASSUME_NONNULL_END
