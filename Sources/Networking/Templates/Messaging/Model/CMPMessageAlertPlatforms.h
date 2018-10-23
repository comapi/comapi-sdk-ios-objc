//
//  CMPMessageAlertPlatforms.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONEncoding.h"
#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPMessageAlertPlatforms : NSObject <CMPJSONEncoding, CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *apns;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *fcm;

- (instancetype)initWithApns:(nullable NSDictionary<NSString *, id> *)apns fcm:(nullable NSDictionary<NSString *, id> *)fcm;

@end

NS_ASSUME_NONNULL_END
