//
//  CMPTestErrors.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 20/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
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
