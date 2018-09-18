//
//  CMPTestAPNSDetails.m
//  comapi_ios_sdk_objective_c_tests
//
//  Created by Dominik Kowalski on 17/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPTestMocks.h"
#import "CMPAPNSDetailsBody.h"

@interface CMPTestAPNSDetailsBody : XCTestCase

@end

@implementation CMPTestAPNSDetailsBody

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJSONDecoding {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"APNSDetailsBody"];
    NSError *error = nil;
    NSDictionary<NSString *, id> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

    CMPAPNSDetails *details = [[CMPAPNSDetails alloc] initWithBundleID:@"id" environment:@"test_env" token:@"aae066f4-399b-4251-8776-b6244c8acbc1"];
    CMPAPNSDetailsBody *object = [[CMPAPNSDetailsBody alloc] initWithAPNSDetails:details];
    if (error) {
        XCTFail();
    }
    
    XCTAssertEqualObjects(object.apns.bundleID, json[@"apns"][@"bundleId"]);
    XCTAssertEqualObjects(object.apns.environment, json[@"apns"][@"environment"]);
    XCTAssertEqualObjects(object.apns.token, json[@"apns"][@"token"]);
}

@end
