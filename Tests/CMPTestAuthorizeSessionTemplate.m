//
//  CMPTestAuthorizeSessionTemplate.m
//  comapi_ios_sdk_objective_c_tests
//
//  Created by Dominik Kowalski on 18/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPTestMocks.h"
#import "CMPAuthorizeSessionTemplate.h"

@interface CMPTestAuthorizeSessionTemplate : XCTestCase

@end

@implementation CMPTestAuthorizeSessionTemplate

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAuthorizeSessionTemplate {
    CMPAuthorizeSessionBody *body = [[CMPAuthorizeSessionBody alloc] initWithAuthenticationID:@"test_auth_id" authenticationToken:[CMPTestMocks mockAuthenticationToken]];
    CMPAuthorizeSessionTemplate *template = [[CMPAuthorizeSessionTemplate alloc] initWithScheme:@"test_scheme" host:@"test_host" port:100 apiSpaceID:[CMPTestMocks mockApiSpaceID] body:body];
    
    XCTAssertEqualObjects(template.scheme, @"test_scheme");
    XCTAssertEqualObjects(template.host, @"test_host");
    XCTAssertEqual(template.port, 100);
    XCTAssertEqualObjects(template.apiSpaceID, @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(template.body.authenticationID, @"test_auth_id");
    XCTAssertEqualObjects(template.body.authenticationToken, @"MOCK_AUTHENTICATION_TOKEN");
    XCTAssertEqualObjects(template.body.deviceID, [[UIDevice currentDevice] model]);
    XCTAssertEqualObjects(template.body.platform, CMPPlatformInfo);
    XCTAssertEqualObjects(template.body.platformVersion, [[UIDevice currentDevice] systemVersion]);
    XCTAssertEqualObjects(template.body.sdkType, CMPSDKType);
    XCTAssertEqualObjects(template.body.sdkVersion, CMPSDKVersion);
}

@end
