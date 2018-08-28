//
//  LoggingDestination.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 28/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPLogLevel.h"

@protocol CMPLoggingDestination <NSObject>

@property (nonatomic, readwrite) CMPLogLevel minimumLogLevel;
@property (nonatomic, readwrite) NSDateFormatter *dateFormatter;

- (NSString *)prefixForLevel:(CMPLogLevel)logLevel;
- (void)logFile:(NSString *)file line:(NSInteger)line function:(NSString *)function items: (NSArray<id> *)items level:(CMPLogLevel)level date:(NSDate *)date;

@end
