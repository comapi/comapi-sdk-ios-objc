//
//  CMPMessageAlert.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMessageAlertPlatforms.h"
#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPMessageAlert : NSObject <CMPJSONEncoding, CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPMessageAlertPlatforms *platforms;

- (instancetype)initWithPlatforms:(nullable CMPMessageAlertPlatforms *)platforms;

@end

NS_ASSUME_NONNULL_END


