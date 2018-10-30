//
//  CMPTestSessionAuth.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 17/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPTestMocks.h"
#import "CMPSessionAuth.h"
#import "CMPResourceLoader.h"

@interface CMPTestSessionAuth : XCTestCase

@end

@implementation CMPTestSessionAuth

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJSONDecoding {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"SessionAuth"];
    CMPSessionAuth *object = [CMPSessionAuth decodeWithData:data];
    
    XCTAssertEqualObjects(object.token, @"aae066f4-399b-4251-8776-b6244c8acbc1");
    XCTAssertEqualObjects(object.session.id, @"f7636495-e553-4abd-a247-c99d1758f5e9");
    XCTAssertEqualObjects(object.session.nonce, @"17796561-bc4c-49b4-a83f-6e6bc7611448");
    XCTAssertEqualObjects(object.session.provider, @"jsonWebToken");
    XCTAssertEqualObjects(object.session.isActive, @(YES));
    XCTAssertEqualObjects(object.session.deviceID, @"iPhone 6,1");
    XCTAssertEqualObjects(object.session.platformVersion, @"10.0.1");
    XCTAssertEqualObjects(object.session.sdkType, @"native");
    XCTAssertEqualObjects(object.session.sdkVersion, @"0.0.1");
    XCTAssertEqualObjects(object.session.sourceIP, @"80.80.80.80");
    XCTAssertEqualObjects(object.session.profileID, @"dominik.kowalski");
}

@end
