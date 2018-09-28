//
//  CMPLogger.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 28/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPLogLevel.h"
#import "CMPLoggingDestination.h"

void logWithLevel(CMPLogLevel logLevel, id params, ...);

NS_ASSUME_NONNULL_BEGIN

@protocol CMPLogging

- (void)logItems:(NSArray<id> *)items level:(CMPLogLevel)level;

- (void)verbose:(NSArray<id> *)params;
- (void)debug:(NSArray<id> *)params;
- (void)info:(NSArray<id> *)params;
- (void)warning:(NSArray<id> *)params;
- (void)error:(NSArray<id> *)params;

@end

@interface CMPLogger : NSObject <CMPLogging>

+ (instancetype)shared;

- (void)addDestination:(id<CMPLoggingDestination>)destination;
- (void)resetDestinations;

@end

NS_ASSUME_NONNULL_END
