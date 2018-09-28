//
//  CMPLogConfig.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 28/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPLogLevel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPLogConfig : NSObject

@property (class, nonatomic, readwrite) CMPLogLevel logLevel;

+ (CMPLogLevel)logLevel;
+ (void)setLogLevel:(CMPLogLevel)logLevel;

@end

NS_ASSUME_NONNULL_END
