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

#import "CMPComapiTest.h"

@interface CMPTestQueryProfilesTemplate : CMPComapiTest

@end

@implementation CMPTestQueryProfilesTemplate

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testQueryProfileTemplate {
    NSArray<CMPQueryElements *> *elements = @[[[CMPQueryElements alloc] initWithKey:@"name" element:CMPQueryElementContains value:@"test"]];
    NSString *query = [CMPQueryBuilder buildQueryWithElements:elements];
    CMPQueryProfilesTemplate *template = [[CMPQueryProfilesTemplate alloc] initWithScheme:@"test_scheme" host:@"test_host" port:100 apiSpaceID:[CMPTestMocks mockApiSpaceID] token:[CMPTestMocks mockAuthenticationToken] queryString:query];
    
    XCTAssertEqualObjects(template.scheme, @"test_scheme");
    XCTAssertEqualObjects(template.host, @"test_host");
    XCTAssertEqual(template.port, 100);
    XCTAssertEqualObjects(template.apiSpaceID, @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(template.token, @"MOCK_AUTHENTICATION_TOKEN");
    XCTAssertEqualObjects(template.queryString, @"?name=~test");
}

@end
