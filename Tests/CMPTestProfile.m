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

@property CMPProfile *object;

@end

@implementation CMPTestProfile

- (void)setUp {
    [super setUp];
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Profile"];
    _object = [CMPProfile decodeWithData:data];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJSONRepresentable {
    NSDictionary *dict = [_object json];
    XCTAssertEqualObjects(dict[@"id"], @"90419e09-1f5b-4fc2-97c8-b878793c53f0");
    XCTAssertEqualObjects(dict[@"email"], @"test@mail.com");
}

- (void)testJSONConstructable {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Profile"];
    NSError *err;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    
    _object = [[CMPProfile alloc] initWithJSON:json];
    
    XCTAssertEqualObjects(_object.id, @"90419e09-1f5b-4fc2-97c8-b878793c53f0");
    XCTAssertEqualObjects(_object.email, @"test@mail.com");
}

- (void)testJSONDecodable {
    XCTAssertEqualObjects(_object.id, @"90419e09-1f5b-4fc2-97c8-b878793c53f0");
    XCTAssertEqualObjects(_object.email, @"test@mail.com");
}

@end
