//
//  CMPTestProfile.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 17/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPTestMocks.h"
#import "CMPProfile.h"
#import "CMPResourceLoader.h"

@interface CMPTestProfile : XCTestCase

@end

@implementation CMPTestProfile

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJSONDecoding {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Profile"];
    CMPProfile *object = [CMPProfile decodeWithData:data];

    XCTAssertEqualObjects(object.id, @"90419e09-1f5b-4fc2-97c8-b878793c53f0");
}

@end
