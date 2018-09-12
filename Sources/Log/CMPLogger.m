//
//  CMPLogger.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 28/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPLogger.h"
#import "CMPConstants.h"
#import "NSDateFormatter+CMPUtility.h"
#import "CMPLog.h"

@interface CMPLogger ()

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSMutableArray<id<CMPLoggingDestination>> * loggingDestinations;

@end

@implementation CMPLogger

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.queue = dispatch_queue_create([CMPQueueNameLog UTF8String], DISPATCH_QUEUE_SERIAL);
        self.dateFormatter = [NSDateFormatter iso8061Formatter];
        self.loggingDestinations = [NSMutableArray new];
    }
    
    return self;
}

+ (instancetype)shared {
    static CMPLogger *instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[CMPLogger alloc] init];
        [instance addDestination:[CMPLog consoleDestination]];
        [instance addDestination:[CMPLog fileDestination]];
    });
    
    return instance;
}

- (void)addDestination:(id<CMPLoggingDestination>)destination {
    dispatch_sync(self.queue, ^{
        [self.loggingDestinations addObject:destination];
    });
}

- (void)logFile:(NSString *)file line:(NSInteger)line function:(NSString *)function items:(NSArray<id> *)items level:(CMPLogLevel)level {
    NSDate *date = [NSDate date];
    dispatch_sync(self.queue, ^{
        
        [self.loggingDestinations enumerateObjectsUsingBlock:^(id<CMPLoggingDestination> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj logFile:file line:line function:function items:items level:level date:date];
        }];
    });
}

- (void)debug:(NSArray<id> *)params {
    [self logFile:[NSString stringWithFormat:@"%s", __FILE__] line:__LINE__ function:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] items:params level:CMPLogLevelDebug];
}

- (void)error:(NSArray<id> *)params {
    [self logFile:[NSString stringWithFormat:@"%s", __FILE__] line:__LINE__ function:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] items:params level:CMPLogLevelError];
}

- (void)info:(NSArray<id> *)params {
    [self logFile:[NSString stringWithFormat:@"%s", __FILE__] line:__LINE__ function:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] items:params level:CMPLogLevelInfo];
}

- (void)verbose:(NSArray<id> *)params {
    [self logFile:[NSString stringWithFormat:@"%s", __FILE__] line:__LINE__ function:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] items:params level:CMPLogLevelVerbose];
}

- (void)warning:(NSArray<id> *)params {
    [self logFile:[NSString stringWithFormat:@"%s", __FILE__] line:__LINE__ function:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] items:params level:CMPLogLevelWarning];
}

@end
