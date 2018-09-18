//
//  CMPTestComapiConfig.m
//  comapi_ios_sdk_objective_c_tests
//
//  Created by Dominik Kowalski on 18/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPComapiConfig.h"
#import "CMPTestMocks.h"

@interface CMPTestComapiConfig : XCTestCase

@end

@implementation CMPTestComapiConfig

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    CMPMockAuthenticationDelegate *delegate = [[CMPMockAuthenticationDelegate alloc] init];
    CMPComapiConfig *config = [[CMPComapiConfig alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:delegate];
    
    XCTAssertEqualObjects(config.id, @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(config.apiConfig.scheme, @"https");
    XCTAssertEqualObjects(config.apiConfig.host, @"stage-api.comapi.com");
    XCTAssertEqual(config.apiConfig.port, 443);
    
    XCTAssertNotNil(config.authDelegate);
    XCTAssertEqualObjects(config.authDelegate, delegate);
}

@end
