//
//  CMPXcodeConsoleDestination.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 28/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPXcodeConsoleDestination.h"
#import "CMPLogLevel.h"
#import "CMPLog.h"
#import "CMPUtilities.h"

@implementation CMPXcodeConsoleDestination

@synthesize minimumLogLevel = _minimumLogLevel;
@synthesize dateFormatter = _dateFormatter;

- (instancetype)initWithMinimumLevel:(CMPLogLevel)minimumLevel {
    self = [super self];
    
    if(self) {
        self.dateFormatter = [NSDateFormatter comapiFormatter];
        self.minimumLogLevel = minimumLevel;
    }
    
    return self;
}

- (NSString *)prefixForLevel:(CMPLogLevel)logLevel {
    return [CMPLogLevelRepresenter emojiRepresentationForLogLevel:logLevel];
}

- (void)logItems:(NSArray<id> *)items level:(CMPLogLevel)level date:(NSDate *)date {
    if (self.minimumLogLevel > level) {
        return;
    }
    
    NSString *prefix = [NSString stringWithFormat:@"%@ %@", [CMPLogLevelRepresenter emojiRepresentationForLogLevel:level], [CMPLogLevelRepresenter textualRepresentationForLogLevel:level]];
    NSString *timeStr = [self.dateFormatter stringFromDate:date];
    NSString *message = [CMPLog stringFromItems:items separator:nil terminator:@""];
    
    NSString *logHeader = [@[prefix, timeStr] componentsJoinedByString:@" "];
    NSString *text = [CMPLog stringFromItems:@[logHeader, message] separator:nil terminator:nil];
    
    NSLog(@"%@", text);
}

@end
