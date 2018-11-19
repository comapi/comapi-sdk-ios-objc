//
//  CMPTestContentData.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 16/11/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPContentData.h"
#import "CMPResourceLoader.h"

@interface CMPTestContentData : XCTestCase

@end

@implementation CMPTestContentData

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testContentDataWithData {
    NSURL *url = [CMPResourceLoader urlForFile:@"mock_image" extension:@"png"];
    NSData *nsdata = [[NSData alloc] initWithContentsOfURL:url];
    CMPContentData *data = [[CMPContentData alloc] initWithData:nsdata type:@"image/png" name:@"mock_image"];
    
    XCTAssertNotNil(data.data);
    XCTAssertTrue([data.data isEqualToData:nsdata]);
    XCTAssertEqualObjects(data.type, @"image/png");
    XCTAssertEqualObjects(data.name, @"mock_image");
}

- (void)testContentDataWithURL {
    NSURL *url = [CMPResourceLoader urlForFile:@"mock_image" extension:@"png"];
    CMPContentData *data = [[CMPContentData alloc] initWithUrl:url type:@"image/png" name:@"mock_image"];
    
    XCTAssertNotNil(data.data);
    XCTAssertTrue([data.data isEqualToData:[[NSData alloc] initWithContentsOfURL:url]]);
    XCTAssertEqualObjects(data.type, @"image/png");
    XCTAssertEqualObjects(data.name, @"mock_image");
}

- (void)testContentDataWithBase64Data {
    NSURL *url = [CMPResourceLoader urlForFile:@"mock_image" extension:@"png"];
    NSData *nsdata = [[NSData alloc] initWithContentsOfURL:url];
    NSString *base64 = [nsdata base64EncodedStringWithOptions:0];
    
    CMPContentData *data = [[CMPContentData alloc] initWithBase64Data:base64 type:@"image/png" name:@"mock_image"];
    
    XCTAssertNotNil(data.data);
    XCTAssertTrue([data.data isEqualToData:nsdata]);
    XCTAssertEqualObjects(data.type, @"image/png");
    XCTAssertEqualObjects(data.name, @"mock_image");
}

@end
