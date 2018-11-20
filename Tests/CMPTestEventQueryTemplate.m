//
//  CMPTestEventQueryTemplate.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 20/11/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPEventQueryTemplate.h"

@interface CMPTestEventQueryTemplate : XCTestCase {
    NSString *scheme;
    NSString *host;
    NSInteger port;
    NSString *apiSpaceID;
    NSString *token;
}

@end

@implementation CMPTestEventQueryTemplate

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

- (void)testEventQueryTemplate {
    CMPEventQueryTemplate *t = [[CMPEventQueryTemplate alloc] initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID conversationID:@"mock_conv_id" from:0 limit:100 token:token];
    
    XCTAssertEqualObjects(t.scheme, @"https://");
    XCTAssertEqualObjects(t.host, @"mock_host.com");
    XCTAssertEqualObjects(t.apiSpaceID, @"8888-8888-8888-8888");
    XCTAssertEqualObjects(t.token, @"mock_token");
    XCTAssertEqualObjects(t.httpMethod, @"GET");
    XCTAssertEqualObjects(t.httpBody, nil);
    NSArray *components = @[@"apispaces", @"8888-8888-8888-8888", @"conversations", @"mock_conv_id", @"events"];
    XCTAssertTrue([t.pathComponents isEqualToArray:components]);
    XCTAssertEqual(t.port, 8080);
    XCTAssertEqual([t.query[@"limit"] integerValue], 100);
    XCTAssertNil(t.query[@"from"]);
    
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
