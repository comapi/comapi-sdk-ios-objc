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

#import <XCTest/XCTest.h>
#import "CMPTestMocks.h"
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

    NSData *encodedData = [sessionBody encode];
    NSDictionary<NSString *, id> *decodedJson = [NSJSONSerialization JSONObjectWithData:encodedData options:0 error:&error];
    CMPAuthorizeSessionBody *decodedSessionBody = [[CMPAuthorizeSessionBody alloc] initWithAuthenticationID:decodedJson[@"authenticationId"] authenticationToken:decodedJson[@"authenticationToken"] deviceID:decodedJson[@"deviceId"] platform:decodedJson[@"platform"] platformVersion:decodedJson[@"platformVersion"] sdkType:decodedJson[@"sdkType"] sdkVersion:decodedJson[@"sdkVersion"]];
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
