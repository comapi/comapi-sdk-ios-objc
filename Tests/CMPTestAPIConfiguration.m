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
#import "CMPAPIConfiguration.h"

@interface CMPTestAPIConfiguration : XCTestCase

@end

@implementation CMPTestAPIConfiguration

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    CMPAPIConfiguration *config = [[CMPAPIConfiguration alloc] initWithScheme:@"scheme" host:@"host" port:100];
    
    XCTAssertEqualObjects(config.scheme, @"scheme");
    XCTAssertEqualObjects(config.host, @"host");
    XCTAssertEqual(config.port, 100);
}

- (void)testProduction {
    CMPAPIConfiguration *production = [CMPAPIConfiguration production];
    
    XCTAssertEqualObjects(production.scheme, @"https");
    XCTAssertEqualObjects(production.host, @"stage-api.comapi.com");
    XCTAssertEqual(production.port, 443);
}

@end
