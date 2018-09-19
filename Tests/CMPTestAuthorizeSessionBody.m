//
//  CMPTestAuthorizeSessionBody.m
//  comapi_ios_sdk_objective_c_tests
//
//  Created by Dominik Kowalski on 17/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPTestMocks.h"
#import "NSString+CMPUtility.h"
#import "CMPAuthorizeSessionBody.h"
#import "CMPResourceLoader.h"

@interface CMPTestAuthorizeSessionBody : XCTestCase

@end

@implementation CMPTestAuthorizeSessionBody

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJSONEncoding {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"AuthorizeSessionBody"];
    NSError *error = nil;
    NSDictionary<NSString *, id> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    CMPAuthorizeSessionBody *sessionBody = [[CMPAuthorizeSessionBody alloc] initWithAuthenticationID:json[@"authenticationId"] authenticationToken:json[@"authenticationToken"] deviceID:json[@"deviceId"] platform:json[@"platform"] platformVersion:json[@"platformVersion"] sdkType:json[@"sdkType"] sdkVersion:json[@"sdkVersion"]];
    if (error) {
        XCTFail();
    }
    
    XCTAssertEqualObjects(sessionBody.authenticationID, @"041636ea-f77f-4a2c-bfb0-6cb3943cec87");
    XCTAssertEqualObjects(sessionBody.platformVersion, @"10.0.1");
    XCTAssertEqualObjects(sessionBody.platform, @"iOS");
    XCTAssertEqualObjects(sessionBody.authenticationToken, @"f6c4003a-c572-48fb-8a01-56b027e20cc3");
    XCTAssertEqualObjects(sessionBody.deviceID, @"iPhone 6,1");
    XCTAssertEqualObjects(sessionBody.sdkType, @"native");

    NSData *encodedData = [sessionBody encode:&error];
    NSDictionary<NSString *, id> *decodedJson = [NSJSONSerialization JSONObjectWithData:encodedData options:0 error:&error];
    CMPAuthorizeSessionBody *decodedSessionBody = [[CMPAuthorizeSessionBody alloc] initWithAuthenticationID:json[@"authenticationId"] authenticationToken:json[@"authenticationToken"] deviceID:json[@"deviceId"] platform:json[@"platform"] platformVersion:json[@"platformVersion"] sdkType:json[@"sdkType"] sdkVersion:json[@"sdkVersion"]];
    if (error) {
        XCTFail();
    }
    
    XCTAssertEqualObjects(decodedSessionBody.authenticationID, @"041636ea-f77f-4a2c-bfb0-6cb3943cec87");
    XCTAssertEqualObjects(decodedSessionBody.platformVersion, @"10.0.1");
    XCTAssertEqualObjects(decodedSessionBody.platform, @"iOS");
    XCTAssertEqualObjects(decodedSessionBody.authenticationToken, @"f6c4003a-c572-48fb-8a01-56b027e20cc3");
    XCTAssertEqualObjects(decodedSessionBody.deviceID, @"iPhone 6,1");
    XCTAssertEqualObjects(decodedSessionBody.sdkType, @"native");
}

@end
