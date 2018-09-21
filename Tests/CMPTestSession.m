//
//  CMPTestSession.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 17/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPTestMocks.h"
#import "NSDateFormatter+CMPUtility.h"
#import "CMPSession.h"
#import "CMPResourceLoader.h"

@interface CMPTestSession : XCTestCase

@end

@implementation CMPTestSession

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJSONEncoding {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Session"];
    NSError *error = nil;
    NSDictionary<NSString *, id> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    CMPSession *session = [[CMPSession alloc] initWithJSON:json];
    if (error) {
        XCTFail();
    }
    
    XCTAssertEqualObjects(session.id, @"5f6c8368-0bec-4bfc-a4b0-d1be4a646361");
    XCTAssertEqualObjects(session.platformVersion, @"11.4");
    XCTAssertEqualObjects(session.platform, @"iOS");
    XCTAssertEqualObjects(session.provider, @"jsonWebToken");
    XCTAssertEqualObjects(session.deviceID, @"iPhone");
    XCTAssertEqualObjects(session.nonce, @"090b604e-183e-4d6e-b0dd-4cc0d916daa7");
    XCTAssertEqualObjects([NSNumber numberWithBool:session.isActive ], @(YES));
    XCTAssertEqualObjects(session.sdkType, @"native");
    XCTAssertEqualObjects(session.sdkVersion, @"1.0.0");
    XCTAssertEqualObjects(session.sourceIP, @"89.73.249.16");
    XCTAssertEqualObjects(session.profileId, @"test1");

    NSData *encodedData = [session encode:&error];
    NSDictionary<NSString *, id> *decodedJson = [NSJSONSerialization JSONObjectWithData:encodedData options:0 error:&error];
    CMPSession *decodedSession = [[CMPSession alloc] initWithJSON:decodedJson];
    if (error) {
        XCTFail();
    }
    
    XCTAssertEqualObjects(decodedSession.id, @"5f6c8368-0bec-4bfc-a4b0-d1be4a646361");
    XCTAssertEqualObjects(decodedSession.platformVersion, @"11.4");
    XCTAssertEqualObjects(decodedSession.platform, @"iOS");
    XCTAssertEqualObjects(decodedSession.provider, @"jsonWebToken");
    XCTAssertEqualObjects(decodedSession.deviceID, @"iPhone");
    XCTAssertEqualObjects(decodedSession.nonce, @"090b604e-183e-4d6e-b0dd-4cc0d916daa7");
    XCTAssertEqualObjects([NSNumber numberWithBool:decodedSession.isActive ], @(YES));
    XCTAssertEqualObjects(decodedSession.sdkType, @"native");
    XCTAssertEqualObjects(decodedSession.sdkVersion, @"1.0.0");
    XCTAssertEqualObjects(decodedSession.sourceIP, @"89.73.249.16");
    XCTAssertEqualObjects(decodedSession.profileId, @"test1");
}

@end
