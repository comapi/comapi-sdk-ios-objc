//
// The MIT License (MIT)
// Copyright (c) 2017 Comapi (trading name of Dynmark International Limited)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <XCTest/XCTest.h>
#import "CMPLogConfig.h"
#import "CMPLogger.h"
#import "CMPConstants.h"
#import "CMPLog.h"
#import "NSDateFormatter+CMPUtility.h"

@interface CMPMockFileDestination : NSObject  <CMPLoggingDestination>

@property dispatch_queue_t queue;
@property NSString *fileName;

- (instancetype)initWithMinimumLevel:(CMPLogLevel)minimumLevel;

@end

@implementation CMPMockFileDestination

@synthesize dateFormatter = _dateFormatter;
@synthesize minimumLogLevel = _minimumLogLevel;

- (instancetype)initWithMinimumLevel:(CMPLogLevel)minimumLevel {
    self = [super self];
    
    if(self) {
        self.minimumLogLevel = minimumLevel;
        self.dateFormatter = [NSDateFormatter iso8061Formatter];
        self.fileName = @"mock.file.destination";
        self.queue = dispatch_queue_create([@"mock_queue" UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (void)logItems:(nonnull NSArray<id> *)items level:(CMPLogLevel)level date:(nonnull NSDate *)date {
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
    
    NSString *loggingPath = [NSString stringWithFormat:@"%@%@", documentsPath, _fileName];
    if (![fileManager fileExistsAtPath:loggingPath]) {
        [fileManager createFileAtPath:loggingPath contents:nil attributes:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:loggingPath];
    [fileHandle truncateFileAtOffset:0];
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        [fileHandle writeData:data];
    }
}

@end

@interface CMPTestLogger : XCTestCase

@end

@implementation CMPTestLogger

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    CMPLogConfig.logLevel = CMPLogLevelVerbose;
    [[CMPLogger shared] resetDestinations];
}

- (void)testLogConfig {
    XCTAssertTrue([CMPLogConfig logLevel] == CMPLogLevelVerbose);
    CMPLogConfig.logLevel = CMPLogLevelInfo;
    XCTAssertTrue([CMPLogConfig logLevel] == CMPLogLevelInfo);
}

- (void)testLogger {
    CMPLogger *logger = [CMPLogger shared];
    
    XCTAssertNotNil(logger);
}

- (void)testFileDestination {
    CMPLogger *logger = [CMPLogger shared];
    CMPMockFileDestination *mockDestination = [[CMPMockFileDestination alloc] initWithMinimumLevel:CMPLogLevelVerbose];
    
    [logger addDestination:mockDestination];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *loggingPath = [NSString stringWithFormat:@"%@%@", documentsPath, @"mock.file.destination"];
    
    logWithLevel(CMPLogLevelInfo, @"test message", nil);

    XCTAssertTrue([fileManager fileExistsAtPath:loggingPath]);
    
    NSData *contents = [fileManager contentsAtPath:loggingPath];
    
    XCTAssertNotNil(contents);
    
    NSString *stringContents = [[NSString alloc] initWithData:contents encoding:NSUTF8StringEncoding];
    
    XCTAssertNotNil(stringContents);
    XCTAssertEqualObjects(@"🚹 INFO \ntest message\n", stringContents);
}

@end




