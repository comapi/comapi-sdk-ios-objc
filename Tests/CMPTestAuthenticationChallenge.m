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

@interface CMPTestAuthenticationChallenge : CMPComapiTest

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
    CMPAuthenticationChallenge *object = [CMPAuthenticationChallenge decodeWithData:data];
    
    XCTAssertEqualObjects(object.authenticationID, @"f6c4003a-c572-48fb-8a01-56b027e20cc3");
    XCTAssertEqualObjects(object.provider, @"jsonWebToken");
    XCTAssertEqualObjects(object.nonce, @"13687106-f26d-4afe-a25a-60d58b38c568");
    XCTAssertEqualObjects(object.expiresOn, [@"2016-09-20T17:06:51.104Z" asDate]);
}

@end
