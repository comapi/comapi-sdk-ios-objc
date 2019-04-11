//
// The MIT License (MIT)
// Copyright (c) 2017 Comapi (trading name of Dynmark International Limited)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "CMPComapiTest.h"

@interface CMPTestContentData : CMPComapiTest

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

- (void)testContentUploadResult {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"ContentUploadResult"];
    CMPContentUploadResult *result = [CMPContentUploadResult decodeWithData:data];
    NSData *encodedData = [result encode];
    NSError *err;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:encodedData options:0 error:&err];
    
    XCTAssertEqualObjects(json[@"id"], @"123");
    XCTAssertEqual([json[@"size"] integerValue], 3801);
    XCTAssertEqualObjects(json[@"type"], @"image/jpeg");
    XCTAssertEqualObjects(json[@"folder"], @"content");
    XCTAssertEqualObjects(json[@"url"], @"https://inttest-content.comapi.com/apispaces/2e7dd112-24f6-422b-bcd4-0f2e91315c0b/content/dc02e4fff450a6306e045f5c26801ce31c3efaeb");
    
    result = [[CMPContentUploadResult alloc] initWithID:@"id" type:@"type" size:@(123) folder:@"folder" url:[NSURL URLWithString:@"url"]];
    
    XCTAssertEqualObjects(result.id, @"id");
    XCTAssertEqual([result.size integerValue], 123);
    XCTAssertEqualObjects(result.type, @"type");
    XCTAssertEqualObjects(result.folder, @"folder");
    XCTAssertEqualObjects(result.url.absoluteString, @"url");
    
}

@end
