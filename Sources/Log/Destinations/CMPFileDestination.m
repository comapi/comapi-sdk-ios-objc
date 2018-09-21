//
//  CMPFileDestination.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 28/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPFileDestination.h"
#import "CMPLogLevel.h"
#import "CMPLog.h"

@interface CMPFileDestination ()

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation CMPFileDestination

@synthesize minimumLogLevel = _minimumLogLevel;
@synthesize dateFormatter = _dateFormatter;

- (instancetype)initWithMinimumLevel:(CMPLogLevel)minimumLevel {
    self = [super self];
    
    if(self) {
        self.minimumLogLevel = minimumLevel;
        self.dateFormatter = [NSDateFormatter iso8061Formatter];
        self.fileName = CMPLogFileName;
        self.queue = dispatch_queue_create([CMPQueueNameFileDestination UTF8String], DISPATCH_QUEUE_SERIAL);
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
    
    [self logToFileWithText:text];
}

- (void)logToFileWithText:(NSString *)text {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString *loggingPath = [NSString stringWithFormat:@"%@%@", documentsPath, self.fileName];
    if (![fileManager fileExistsAtPath:loggingPath]) {
        [fileManager createFileAtPath:loggingPath contents:nil attributes:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:loggingPath];
    [fileHandle seekToEndOfFile];
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        [fileHandle writeData:data];
    }
}

@end
