//
//  CMPTestAPIConfiguration.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 18/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPAPIConfiguration.h"

@interface CMPTestAPIConfiguration : XCTestCase

@end

@implementation CMPTestAPIConfiguration

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    CMPAPIConfiguration *config = [[CMPAPIConfiguration alloc] initWithScheme:@"scheme" host:@"host" port:100];
    
    XCTAssertEqualObjects(config.scheme, @"scheme");
    XCTAssertEqualObjects(config.host, @"host");
    XCTAssertEqual(config.port, 100);
}

- (void)testProduction {
    CMPAPIConfiguration *production = [CMPAPIConfiguration production];
    
    XCTAssertEqualObjects(production.scheme, @"https");
    XCTAssertEqualObjects(production.host, @"stage-api.comapi.com");
    XCTAssertEqual(production.port, 443);
}

@end
