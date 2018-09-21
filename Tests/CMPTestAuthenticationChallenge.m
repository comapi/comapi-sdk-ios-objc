//
//  CMPTestAuthenticationChallenge.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 17/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPResourceLoader.h"
#import "CMPTestMocks.h"
#import "CMPAuthenticationChallenge.h"

@interface CMPTestAuthenticationChallenge : XCTestCase

@end

@implementation CMPTestAuthenticationChallenge

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testJSONDecoding {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"AuthenticationChallenge"];
    NSError *error = nil;
    CMPAuthenticationChallenge *object = [[CMPAuthenticationChallenge alloc] decodeWithData:data error:&error];
    if (error) {
        XCTFail();
    }
    
    XCTAssertEqualObjects(object.authenticationID, @"f6c4003a-c572-48fb-8a01-56b027e20cc3");
    XCTAssertEqualObjects(object.provider, @"jsonWebToken");
    XCTAssertEqualObjects(object.nonce, @"13687106-f26d-4afe-a25a-60d58b38c568");
    XCTAssertEqualObjects(object.expiresOn, [@"2016-09-20T17:06:51.104Z" asDate]);
}

@end
