//
//  CMPTestDeleteSessionTemplate.m
//  comapi_ios_sdk_objective_c_tests
//
//  Created by Dominik Kowalski on 18/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPTestMocks.h"
#import "CMPDeleteSessionTemplate.h"

@interface CMPTestDeleteSessionTemplate : XCTestCase

@end

@implementation CMPTestDeleteSessionTemplate

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAuthorizeSessionTemplate {
    CMPDeleteSessionTemplate *template = [[CMPDeleteSessionTemplate alloc] initWithScheme:@"test_scheme" host:@"test_host" port:100 apiSpaceID:[CMPTestMocks mockApiSpaceID] token:[CMPTestMocks mockAuthenticationToken] sessionID:@"test_session_id"];
    
    XCTAssertEqualObjects(template.scheme, @"test_scheme");
    XCTAssertEqualObjects(template.host, @"test_host");
    XCTAssertEqual(template.port, 100);
    XCTAssertEqualObjects(template.apiSpaceID, @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(template.token, @"MOCK_AUTHENTICATION_TOKEN");
    XCTAssertEqualObjects(template.sessionID, @"test_session_id");
}

@end
