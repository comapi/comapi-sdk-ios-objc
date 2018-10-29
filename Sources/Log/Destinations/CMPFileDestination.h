//
//  CMPFileDestination.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 28/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPLoggingDestination.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(FileDestination)
@interface CMPFileDestination : NSObject <CMPLoggingDestination>

- (instancetype)initWithMinimumLevel:(CMPLogLevel)minimumLevel;

@end

NS_ASSUME_NONNULL_END
