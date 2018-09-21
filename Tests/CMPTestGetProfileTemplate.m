//
//  CMPTestGetProfileTemplate.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 18/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPTestMocks.h"
#import "CMPGetProfileTemplate.h"

@interface CMPTestGetProfileTemplate : XCTestCase

@end

@implementation CMPTestGetProfileTemplate

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetProfileTemplate {
    CMPGetProfileTemplate *template = [[CMPGetProfileTemplate alloc] initWithScheme:@"test_scheme" host:@"test_host" port:100 apiSpaceID:[CMPTestMocks mockApiSpaceID] profileID:@"test_id" token:[CMPTestMocks mockAuthenticationToken]];
    
    XCTAssertEqualObjects(template.scheme, @"test_scheme");
    XCTAssertEqualObjects(template.host, @"test_host");
    XCTAssertEqual(template.port, 100);
    XCTAssertEqualObjects(template.apiSpaceID, @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(template.profileID, @"test_id");
    XCTAssertEqualObjects(template.token, @"MOCK_AUTHENTICATION_TOKEN");
}

@end
