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

@interface CMPTestGetParticipantsTemplate : CMPComapiTest {
    NSString *scheme;
    NSString *host;
    NSInteger port;
    NSString *apiSpaceID;
    NSString *token;
}

@end

@implementation CMPTestGetParticipantsTemplate

- (void)setUp {
    scheme = @"https://";
    host = @"mock_host.com";
    port = 8080;
    apiSpaceID = @"8888-8888-8888-8888";
    token = @"mock_token";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testGetParticipantsTemplate {
    CMPGetParticipantsTemplate *t = [[CMPGetParticipantsTemplate alloc] initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID conversationID:@"mock_conv_id" token:token];
    
    XCTAssertEqualObjects(t.scheme, @"https://");
    XCTAssertEqualObjects(t.host, @"mock_host.com");
    XCTAssertEqualObjects(t.apiSpaceID, @"8888-8888-8888-8888");
    XCTAssertEqualObjects(t.token, @"mock_token");
    XCTAssertEqualObjects(t.httpMethod, @"GET");
    XCTAssertEqualObjects(t.httpBody, nil);
    NSArray *components = @[@"apispaces", @"8888-8888-8888-8888", @"conversations", @"mock_conv_id", @"participants"];
    XCTAssertTrue([t.pathComponents isEqualToArray:components]);
    XCTAssertEqual(t.port, 8080);
    XCTAssertNil(t.query);
    
    NSArray<CMPHTTPHeader *> *headers = [t.httpHeaders allObjects];
    
    XCTAssertTrue([headers count] == 2);
    
    [headers enumerateObjectsUsingBlock:^(CMPHTTPHeader * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.field isEqualToString:@"Content-Type"]) {
            XCTAssertTrue([obj.value isEqualToString:@"application/json"]);
        } else if ([obj.field isEqualToString:@"Authorization"]) {
            XCTAssertTrue([obj.value isEqualToString:@"Bearer mock_token"]);
        } else {
            XCTFail();
        }
    }];
}

@end
