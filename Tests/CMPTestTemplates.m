//
//  CMPTestTemplates.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 19/11/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPTestMocks.h"
#import "CMPEventQueryTemplate.h"

@interface CMPTestTemplates : XCTestCase {
    NSString *scheme;
    NSString *host;
    NSInteger port;
    NSString *apiSpaceID;
    NSString *token;
}

@end

@implementation CMPTestTemplates

- (void)setUp {
    scheme = @"https://";
    host = @"mock_host.com";
    port = 8080;
    apiSpaceID = @"8888-8888-8888-8888";
    token = @"mock_token";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testEventQueryTemplate {
    CMPEventQueryTemplate *t = [[CMPEventQueryTemplate alloc] initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID conversationID:@"mock_conv_id" from:0 limit:100 token:token];
    
    XCTAssertEqualObjects(t.scheme, @"https://");
    XCTAssertEqualObjects(t.host, @"mock_host.com");
    XCTAssertEqual(t.port, 8080);
    XCTAssertEqualObjects(t.apiSpaceID, @"8888-8888-8888-8888");
    XCTAssertEqualObjects(t.token, @"mock_token");
    XCTAssertEqualObjects(t.httpMethod, @"GET");
    XCTAssertEqualObjects(t.httpBody, nil);
    
    NSArray<CMPHTTPHeader *> *headers = [t.httpHeaders allObjects];
    
    XCTAssertTrue([headers count] == 2);
    
    [headers enumerateObjectsUsingBlock:^(CMPHTTPHeader * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.field isEqualToString:@"Content-Type"]) {
            XCTAssertTrue([obj.value isEqualToString:@"application/json"]);
        } else if ([obj.field isEqualToString:@"Authorization"]) {
            XCTAssertTrue([obj.value isEqualToString:@"Bearer mock_token"]);
        } else {
            XCTFail();
        }
    }];
}

- (void)testGetParticipantsTemplate {
    
}

- (void)testAddParticipantsTemplate {
    
}

- (void)testRemoveParticipantsTemplate {
    
}

- (void)testGetConversationTemplate {
    
}

- (void)testAddConversationTemplate {
    
}

- (void)testUpdateConversationTemplate {
    
}

- (void)testDeleteConversationTemplate {
    
}

- (void)testGetMessagesTemplate {
    
}

- (void)testSendMessagesTemplate {
    
}

- (void)testContentUploadTemplate {
    
}

- (void)testSendStatusUpdateTemplate {
    
}

@end
