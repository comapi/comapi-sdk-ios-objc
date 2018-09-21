//
//  CMPTestSetAPNSDetailsTemplate.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 18/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPTestMocks.h"
#import "CMPSetAPNSDetailsTemplate.h"

@interface CMPTestSetAPNSDetailsTemplate : XCTestCase

@end

@implementation CMPTestSetAPNSDetailsTemplate

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAuthorizeSessionTemplate {
    CMPAPNSDetails *details = [[CMPAPNSDetails alloc] initWithBundleID:@"test_bundle_id" environment:@"test_environment" token:[CMPTestMocks mockAuthenticationToken]];
    CMPAPNSDetailsBody *body = [[CMPAPNSDetailsBody alloc] initWithAPNSDetails:details];
    CMPSetAPNSDetailsTemplate *template = [[CMPSetAPNSDetailsTemplate alloc] initWithScheme:@"test_scheme" host:@"test_host" port:100 apiSpaceID:[CMPTestMocks mockApiSpaceID] token:[CMPTestMocks mockAuthenticationToken] sessionID:@"test_session_id" body:body];
    
    XCTAssertEqualObjects(template.scheme, @"test_scheme");
    XCTAssertEqualObjects(template.host, @"test_host");
    XCTAssertEqual(template.port, 100);
    XCTAssertEqualObjects(template.apiSpaceID, @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(template.token, @"MOCK_AUTHENTICATION_TOKEN");
    XCTAssertEqualObjects(template.sessionID, @"test_session_id");
    XCTAssertEqualObjects(template.body.apns.environment, @"test_environment");
    XCTAssertEqualObjects(template.body.apns.bundleID, @"test_bundle_id");
    XCTAssertEqualObjects(template.body.apns.token, @"MOCK_AUTHENTICATION_TOKEN");
}

@end
