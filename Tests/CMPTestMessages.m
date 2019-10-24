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

@interface CMPTestMessages : CMPComapiTest

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
    
    CMPMessageParticipant *participant = [[CMPMessageParticipant alloc] initWithID:@"participantID" name:@"name" avatarURL:@"avatarUrl"];
    CMPMessageContext *context = [[CMPMessageContext alloc] initWithConversationID:@"conversationId" from:participant sentBy:@"sender" sentOn:[NSDate date]];
    CMPMessagePart *part = [[CMPMessagePart alloc] initWithName:@"partName" type:@"partType" url:[NSURL URLWithString:@"partURL"] data:@"partData" size:@(123)];
    CMPMessageStatus *statusUpdate = [[CMPMessageStatus alloc] initWithStatus:CMPMessageDeliveryStatusRead timestamp:[NSDate date]];
    msg = [[CMPMessage alloc] initWithID:@"id" sentEventID:@(1) metadata:@{} context:context parts:@[part] statusUpdates:@{@"update1" : statusUpdate}];

    XCTAssertEqualObjects(msg.id, @"id");
    XCTAssertEqualObjects(msg.context.from.id, @"participantID");
    XCTAssertEqualObjects(msg.context.from.name, @"name");
    XCTAssertEqualObjects(msg.context.conversationID, @"conversationId");
    XCTAssertEqualObjects(msg.context.sentBy, @"sender");
    //XCTAssertEqualObjects([msg.context.sentOn ISO8061String], @"2016-09-29T09:17:46.534Z");
    XCTAssertEqualObjects(msg.parts[0].name, @"partName");
    XCTAssertEqualObjects(msg.parts[0].type, @"partType");
    XCTAssertEqualObjects(msg.parts[0].url.absoluteString, @"partURL");
    XCTAssertEqualObjects(msg.parts[0].data, @"partData");
    XCTAssertEqual(msg.parts[0].size.integerValue, 123);
    XCTAssertEqual(msg.statusUpdates.count, 1);
    XCTAssertEqual(msg.statusUpdates[@"update1"].status, CMPMessageDeliveryStatusRead);
    //XCTAssertEqualObjects(msg.statusUpdates[@"update1"].timestamp, @"status");
}

- (void)testMessageStatusUpdate {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"MessageStatusUpdate"];
    
    CMPMessageStatus *status = [CMPMessageStatus decodeWithData:data];
    
    XCTAssertEqual(status.status, CMPMessageDeliveryStatusDelivered);
    XCTAssertEqualObjects([status.timestamp ISO8061String], @"2016-06-22T10:45:49.718Z");
    
    NSDictionary *json = [status json];
    
    XCTAssertEqualObjects(json[@"status"], @"delivered");
    XCTAssertEqualObjects(json[@"timestamp"], @"2016-06-22T10:45:49.718Z");
}

- (void)testMessageAlertPlatforms {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"MessageAlert"];
    
    CMPMessageAlert *alert = [CMPMessageAlert decodeWithData:data];
    
    XCTAssertEqualObjects(alert.platforms.apns[@"key1"], @"val1");
    XCTAssertEqualObjects(alert.platforms.fcm[@"key2"], @"val2");
    
    NSDictionary *json = [alert json];
    
    XCTAssertEqualObjects(json[@"platforms"][@"apns"][@"key1"], @"val1");
    XCTAssertEqualObjects(json[@"platforms"][@"fcm"][@"key2"], @"val2");
    
    CMPMessageAlertPlatforms *platform = [[CMPMessageAlertPlatforms alloc] initWithApns:@{@"apnsKey" : @"apnsVal"} fcm:@{@"fcmKey" : @"fcmVal"}];
    alert = [[CMPMessageAlert alloc] initWithPlatforms:platform];
    
    XCTAssertEqualObjects(alert.platforms.apns[@"apnsKey"], @"apnsVal");
    XCTAssertEqualObjects(alert.platforms.fcm[@"fcmKey"], @"fcmVal");
}

- (void)testGetMessagesResult {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"GetMessagesResult"];
    
    CMPGetMessagesResult *result = [CMPGetMessagesResult decodeWithData:data];
    
    XCTAssertEqual([result.latestEventID integerValue], 35);
    XCTAssertEqual([result.earliestEventID integerValue], 34);
    XCTAssertEqualObjects(result.messages[0].id, @"c8ee2dff-fc46-4248-843f-76b6d4b621ca");
    XCTAssertEqualObjects(result.messages[0].metadata[@"id"], @"metadata id");
    XCTAssertEqualObjects(result.messages[0].metadata[@"color"], @"red");
    XCTAssertEqual([result.messages[0].metadata[@"count"] integerValue], 3);
    XCTAssertEqual([result.messages[0].metadata[@"other"] doubleValue], 3.553);
    XCTAssertEqualObjects(result.messages[0].context.from.id, @"dominik.kowalski");
    XCTAssertEqualObjects(result.messages[0].context.from.name, @"dominik.kowalski");
    XCTAssertEqualObjects(result.messages[0].context.conversationID, @"support");
    XCTAssertEqualObjects(result.messages[0].context.sentBy, @"dominik.kowalski");
    XCTAssertEqualObjects([result.messages[0].context.sentOn ISO8061String], @"2016-09-29T09:17:46.534Z");
    XCTAssertEqualObjects(result.messages[0].parts[0].name, @"PartName");
    XCTAssertEqualObjects(result.messages[0].parts[0].type, @"image/jpeg");
    XCTAssertEqualObjects(result.messages[0].parts[0].url.absoluteString, @"apple.com");
    XCTAssertEqualObjects(result.messages[0].parts[0].data, @"base64EncodedData");
    //XCTAssertEqualObjects(result., @"PartName");
    XCTAssertEqualObjects(result.messages[0].parts[0].type, @"image/jpeg");
    XCTAssertEqualObjects(result.messages[0].parts[0].url.absoluteString, @"apple.com");
    XCTAssertEqualObjects(result.messages[0].parts[0].data, @"base64EncodedData");
    
    
    XCTAssertEqual([result.messages[0].parts[0].size integerValue], 12535);
    
    NSDictionary *json = [result json];
    
    XCTAssertEqual([json[@"latestEventId"] integerValue], 35);
    XCTAssertEqual([json[@"earliestEventId"] integerValue], 34);
    XCTAssertEqualObjects(json[@"messages"][0][@"id"], @"c8ee2dff-fc46-4248-843f-76b6d4b621ca");
    XCTAssertEqualObjects(json[@"messages"][0][@"metadata"][@"id"], @"metadata id");
    XCTAssertEqualObjects(json[@"messages"][0][@"metadata"][@"color"], @"red");
    XCTAssertEqual([json[@"messages"][0][@"metadata"][@"count"] integerValue], 3);
    XCTAssertEqual([json[@"messages"][0][@"metadata"][@"other"] doubleValue], 3.553);
    XCTAssertEqualObjects(json[@"messages"][0][@"context"][@"from"][@"id"], @"dominik.kowalski");
    XCTAssertEqualObjects(json[@"messages"][0][@"context"][@"from"][@"name"], @"dominik.kowalski");
    XCTAssertEqualObjects(json[@"messages"][0][@"context"][@"conversationId"], @"support");
    XCTAssertEqualObjects(json[@"messages"][0][@"context"][@"sentBy"], @"dominik.kowalski");
    XCTAssertEqualObjects(json[@"messages"][0][@"context"][@"sentOn"], @"2016-09-29T09:17:46.534Z");
    XCTAssertEqualObjects(json[@"messages"][0][@"parts"][0][@"name"], @"PartName");
    XCTAssertEqualObjects(json[@"messages"][0][@"parts"][0][@"type"], @"image/jpeg");
    XCTAssertEqualObjects(json[@"messages"][0][@"parts"][0][@"url"], @"apple.com");
    XCTAssertEqualObjects(json[@"messages"][0][@"parts"][0][@"data"], @"base64EncodedData");
    XCTAssertEqual([json[@"messages"][0][@"parts"][0][@"size"] integerValue], 12535);
    
    result = [[CMPGetMessagesResult alloc] initWithLatestEventID:@(1) earliestEventID:@(1) messages:@[] orphanedEvents:@[]];
    
    XCTAssertEqual([result.latestEventID integerValue], 1);
    XCTAssertEqual([result.earliestEventID integerValue], 1);
    XCTAssertEqual([result.messages count], 0);
    XCTAssertEqual([result.orphanedEvents count], 0);
}

@end
