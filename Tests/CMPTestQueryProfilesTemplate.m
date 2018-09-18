//
//  CMPTestQueryProfilesTemplate.m
//  comapi_ios_sdk_objective_c_tests
//
//  Created by Dominik Kowalski on 18/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPTestMocks.h"
#import "CMPQueryBuilder.h"
#import "CMPQueryProfilesTemplate.h"

@interface CMPTestQueryProfilesTemplate : XCTestCase

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
