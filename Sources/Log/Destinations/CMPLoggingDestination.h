//
//  LoggingDestination.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 28/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPLogLevel.h"

#define NSLog(FORMAT, ...) fprintf(stderr, "%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(LoggingDestination)
@protocol CMPLoggingDestination <NSObject>

@property (nonatomic, readwrite) CMPLogLevel minimumLogLevel;
@property (nonatomic, readwrite) NSDateFormatter *dateFormatter;

- (NSString *)prefixForLevel:(CMPLogLevel)logLevel;
- (void)logItems:(NSArray<id> *)items level:(CMPLogLevel)level date:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
