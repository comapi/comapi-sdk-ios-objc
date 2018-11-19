//
//  CMPTestMessages.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 16/11/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPMessage.h"
#import "CMPResourceLoader.h"
#import "NSDate+CMPUtility.h"

@interface CMPTestMessages : XCTestCase

@end

@implementation CMPTestMessages

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testMessage {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Message"];
    
    CMPMessage *msg = [CMPMessage decodeWithData:data];
    
    XCTAssertEqualObjects(msg.id, @"c8ee2dff-fc46-4248-843f-76b6d4b621ca");
    XCTAssertEqualObjects(msg.metadata[@"id"], @"coolass id");
    XCTAssertEqualObjects(msg.metadata[@"color"], @"red");
    XCTAssertEqual([(NSNumber *)msg.metadata[@"count"] integerValue], 3);
    XCTAssertEqual([(NSNumber *)msg.metadata[@"other"] doubleValue], 3.553);
    XCTAssertEqualObjects(msg.context.from.id, @"USER\\alex.stevens");
    XCTAssertEqualObjects(msg.context.from.name, @"USER\\alex.stevens");
    XCTAssertEqualObjects(msg.context.conversationID, @"support");
    XCTAssertEqualObjects(msg.context.sentBy, @"USER\\alex.stevens");
    XCTAssertEqualObjects([msg.context.sentOn ISO8061String], @"2016-09-29T09:17:46.534Z");
    XCTAssertEqualObjects(msg.parts[0].name, @"PartName");
    XCTAssertEqualObjects(msg.parts[0].type, @"image/jpeg");
    XCTAssertEqualObjects(msg.parts[0].url.absoluteString, @"http://apple.com");
    XCTAssertEqualObjects(msg.parts[0].data, @"base64EncodedData");
    XCTAssertEqual(msg.parts[0].size.integerValue, 12535);
    XCTAssertEqual(msg.statusUpdates.count, 0);
    
    NSDictionary *json = [msg json];
    
    XCTAssertEqualObjects(json[@"id"], @"c8ee2dff-fc46-4248-843f-76b6d4b621ca");
    XCTAssertEqualObjects(json[@"metadata"][@"id"], @"coolass id");
    XCTAssertEqualObjects(json[@"metadata"][@"color"], @"red");
    XCTAssertEqual([(NSNumber *)json[@"metadata"][@"count"] integerValue], 3);
    XCTAssertEqual([(NSNumber *)json[@"metadata"][@"other"] doubleValue], 3.553);
    XCTAssertEqualObjects(json[@"context"][@"from"][@"id"], @"USER\\alex.stevens");
    XCTAssertEqualObjects(json[@"context"][@"from"][@"name"], @"USER\\alex.stevens");
    XCTAssertEqualObjects(json[@"context"][@"conversationId"], @"support");
    XCTAssertEqualObjects(json[@"context"][@"sentBy"], @"USER\\alex.stevens");
    XCTAssertEqualObjects(json[@"context"][@"sentOn"], @"2016-09-29T09:17:46.534Z");
    XCTAssertEqualObjects(json[@"parts"][0][@"name"], @"PartName");
    XCTAssertEqualObjects(json[@"parts"][0][@"type"], @"image/jpeg");
    XCTAssertEqualObjects(json[@"parts"][0][@"url"], @"http://apple.com");
    XCTAssertEqualObjects(json[@"parts"][0][@"data"], @"base64EncodedData");
    XCTAssertEqual([(NSNumber *)json[@"parts"][0][@"size"] integerValue], 12535);
    XCTAssertEqual([(NSArray *)json[@"statusUpdates"] count], 0);
}

- (void)testMessageStatusUpdate {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"MessageStatusUpdate"];
    
    CMPMessageStatus *status = [CMPMessageStatus decodeWithData:data];
    
    XCTAssertEqualObjects(status.status, @"delivered");
    XCTAssertEqualObjects([status.timestamp ISO8061String], @"2016-06-22T10:45:49.718Z");
    
    NSDictionary *json = [status json];
    
    XCTAssertEqualObjects(json[@"status"], @"delivered");
    XCTAssertEqualObjects(json[@"timestamp"], @"2016-06-22T10:45:49.718Z");
}

@end
