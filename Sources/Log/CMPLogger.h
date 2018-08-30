//
//  CMPLogger.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 28/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPLogLevel.h"
#import "CMPLoggingDestination.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CMPLogging

- (void)logFile:(NSString *)file line:(NSInteger)line function:(NSString *)function items: (NSArray<id> *)items level:(CMPLogLevel)level;

@end

@interface CMPLogger : NSObject <CMPLogging>

+ (instancetype)shared;

- (void)verbose:(id)params, ...;
- (void)debug:(id)params, ...;
- (void)info:(id)params, ...;
- (void)warning:(id)params, ...;
- (void)error:(id)params, ...;

- (void)addDestination:(id<CMPLoggingDestination>)destination;

@end

NS_ASSUME_NONNULL_END
