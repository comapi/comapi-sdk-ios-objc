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
#import "CMPErrors.h"

@interface CMPTestErrors : XCTestCase

@end

@implementation CMPTestErrors

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRequestTemplateErrors {
    NSError *requestCreationFailed = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorRequestCreationFailed underlyingError:nil];
    
    XCTAssertEqual(requestCreationFailed.code, 5551);
    XCTAssertEqualObjects(requestCreationFailed.domain, @"com.comapi.foundation.request.template");
    
    NSError *responseParsingFailed = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorResponseParsingFailed underlyingError:nil];
    
    XCTAssertEqual(responseParsingFailed.code, 5552);
    XCTAssertEqualObjects(responseParsingFailed.domain, @"com.comapi.foundation.request.template");
    
    NSError *connectionFailed = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorConnectionFailed underlyingError:nil];
    
    XCTAssertEqual(connectionFailed.code, 5553);
    XCTAssertEqualObjects(connectionFailed.domain, @"com.comapi.foundation.request.template");
    
    NSError *unexpectedStatusCode = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorUnexpectedStatusCode underlyingError:nil];
    
    XCTAssertEqual(unexpectedStatusCode.code, 5554);
    XCTAssertEqualObjects(unexpectedStatusCode.domain, @"com.comapi.foundation.request.template");
    
    NSError *notFound = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorNotFound underlyingError:nil];
    
    XCTAssertEqual(notFound.code, 5555);
    XCTAssertEqualObjects(notFound.domain, @"com.comapi.foundation.request.template");
    
    NSError *updateConflict = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorUpdateConflict underlyingError:nil];
    
    XCTAssertEqual(updateConflict.code, 5556);
    XCTAssertEqualObjects(updateConflict.domain, @"com.comapi.foundation.request.template");
}

- (void)testAuthenticationErrors {
    NSError *missingToken = [CMPErrors authenticationErrorWithStatus:CMPAuthenticationErrorMissingToken  underlyingError:nil];
    
    XCTAssertEqual(missingToken.code, 5561);
    XCTAssertEqualObjects(missingToken.domain, @"com.comapi.foundation.authentication");
}

@end
