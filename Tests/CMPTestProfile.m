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
#import "CMPTestMocks.h"
#import "CMPProfile.h"
#import "CMPResourceLoader.h"

@interface CMPTestProfile : XCTestCase

@property CMPProfile *object;

@end

@implementation CMPTestProfile

- (void)setUp {
    [super setUp];
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Profile"];
    _object = [CMPProfile decodeWithData:data];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testJSONRepresentable {
    NSDictionary *dict = [_object json];
    XCTAssertEqualObjects(dict[@"id"], @"90419e09-1f5b-4fc2-97c8-b878793c53f0");
    XCTAssertEqualObjects(dict[@"email"], @"test@mail.com");
}

- (void)testJSONConstructable {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Profile"];
    NSError *err;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    
    _object = [[CMPProfile alloc] initWithJSON:json];
    
    XCTAssertEqualObjects(_object.id, @"90419e09-1f5b-4fc2-97c8-b878793c53f0");
    XCTAssertEqualObjects(_object.email, @"test@mail.com");
}

- (void)testJSONDecodable {
    XCTAssertEqualObjects(_object.id, @"90419e09-1f5b-4fc2-97c8-b878793c53f0");
    XCTAssertEqualObjects(_object.email, @"test@mail.com");
}

@end
