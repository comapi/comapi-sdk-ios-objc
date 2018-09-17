//
//  CMPTestProfile.m
//  comapi_ios_sdk_objective_c_tests
//
//  Created by Dominik Kowalski on 17/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPTestMocks.h"
#import "NSString+CMPUtility.h"
#import "CMPProfile.h"

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
    NSError *error = nil;
    CMPProfile *object = [[CMPProfile alloc] decodeWithData:data error:&error];
    if (error) {
        XCTFail();
    }

    XCTAssertEqualObjects(object.id, @"90419e09-1f5b-4fc2-97c8-b878793c53f0");
    XCTAssertEqualObjects(object.createdOn, [@"2018-07-03T11:25:46.047Z" asDate]);
    XCTAssertEqualObjects(object.createdBy, @"interactive:dominik.kowalski@comapi.com");
    XCTAssertEqualObjects(object.updatedOn, [@"2018-07-03T11:25:46.047Z" asDate]);
    XCTAssertEqualObjects(object.updatedBy, @"interactive:dominik.kowalski@comapi.com");
}

@end
