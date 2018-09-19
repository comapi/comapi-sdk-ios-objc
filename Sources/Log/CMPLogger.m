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

void logWithLevel(CMPLogLevel logLevel, id params, ...) {
    NSMutableArray *arguments = [NSMutableArray new];
    id eachObject;
    va_list argumentList;
    if (params)
    {
        [arguments addObject: params];
        va_start(argumentList, params);
        while ((eachObject = va_arg(argumentList, id)))
        {
            [arguments addObject: eachObject];
        }
        va_end(argumentList);
    }
    
    switch (logLevel) {
        case CMPLogLevelInfo:
            [[CMPLogger shared] info:arguments];
            break;
        case CMPLogLevelVerbose:
            [[CMPLogger shared] verbose:arguments];
            break;
        case CMPLogLevelError:
            [[CMPLogger shared] error:arguments];
            break;
        case CMPLogLevelDebug:
            [[CMPLogger shared] debug:arguments];
            break;
        case CMPLogLevelWarning:
            [[CMPLogger shared] warning:arguments];
            break;
    }
}

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

- (void)logItems:(NSArray<id> *)items level:(CMPLogLevel)level {
    NSDate *date = [NSDate date];
    dispatch_sync(self.queue, ^{
        [self.loggingDestinations enumerateObjectsUsingBlock:^(id<CMPLoggingDestination> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj logItems:items level:level date:date];
        }];
    });
}

- (void)debug:(NSArray<id> *)params {
    [self logItems:params level:CMPLogLevelDebug];
}

- (void)error:(NSArray<id> *)params {
    [self logItems:params level:CMPLogLevelError];
}

- (void)info:(NSArray<id> *)params {
    [self logItems:params level:CMPLogLevelInfo];
}

- (void)verbose:(NSArray<id> *)params {
    [self logItems:params level:CMPLogLevelVerbose];
}

- (void)warning:(NSArray<id> *)params {
    [self logItems:params level:CMPLogLevelWarning];
}

@end
