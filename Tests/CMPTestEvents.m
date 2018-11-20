//
//  CMPTestEvents.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 15/11/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPResourceLoader.h"
#import "CMPConversationMessageEvents.h"
#import "CMPConversationEvents.h"
#import "CMPSocketEvents.h"
#import "CMPProfileEvents.h"
#import "NSDateFormatter+CMPUtility.h"

@interface CMPTestEvents : XCTestCase

@end

@implementation CMPTestEvents

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testConversationCreate {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Event.conversation.create"];
    
    CMPConversationEventCreate *event = [CMPConversationEventCreate decodeWithData:data];
    
    XCTAssertEqualObjects(event.eventID, @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(event.apiSpaceID, @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(event.name, @"conversation.create");
    XCTAssertEqualObjects(event.context.createdBy, @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqualObjects(event.conversationID, @"myConversation");
    XCTAssertEqualObjects(event.payload.id, @"myConversation");
    XCTAssertEqualObjects(event.payload.participants[0].id, @"alex");
    XCTAssertEqualObjects(event.payload.participants[0].role, @"owner");
    XCTAssertEqual([event.conversationEventID integerValue], 123);
    XCTAssertEqual([event.payload.isPublic boolValue], YES);
    XCTAssertEqual(event.payload.roles.owner.canSend, YES);
    XCTAssertEqual(event.payload.roles.owner.canAddParticipants, NO);
    XCTAssertEqual(event.payload.roles.owner.canRemoveParticipants, YES);
    XCTAssertEqual(event.payload.roles.participant.canSend, YES);
    XCTAssertEqual(event.payload.roles.participant.canAddParticipants, NO);
    XCTAssertEqual(event.payload.roles.participant.canRemoveParticipants, YES);
    
    NSDictionary *json = [event json];
    
    XCTAssertEqualObjects(json[@"eventId"], @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(json[@"apiSpaceId"], @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(json[@"name"], @"conversation.create");
    XCTAssertEqualObjects(json[@"context"][@"createdBy"], @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqualObjects(json[@"payload"][@"id"], @"myConversation");
    XCTAssertEqualObjects(json[@"payload"][@"participants"][0][@"id"], @"alex");
    XCTAssertEqualObjects(json[@"payload"][@"participants"][0][@"role"], @"owner");
    XCTAssertEqual([json[@"conversationEventId"] integerValue], 123);
    XCTAssertEqual([json[@"payload"][@"isPublic"] boolValue], YES);
    XCTAssertEqual([json[@"payload"][@"roles"][@"owner"][@"canSend"] boolValue], YES);
    XCTAssertEqual([json[@"payload"][@"roles"][@"owner"][@"canAddParticipants"] boolValue], NO);
    XCTAssertEqual([json[@"payload"][@"roles"][@"owner"][@"canRemoveParticipants"] boolValue], YES);
    XCTAssertEqual([json[@"payload"][@"roles"][@"participant"][@"canSend"] boolValue], YES);
    XCTAssertEqual([json[@"payload"][@"roles"][@"participant"][@"canAddParticipants"] boolValue], NO);
    XCTAssertEqual([json[@"payload"][@"roles"][@"participant"][@"canRemoveParticipants"] boolValue], YES);
}

- (void)testConversationDelete {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Event.conversation.delete"];
    
    CMPConversationEventDelete *event = [CMPConversationEventDelete decodeWithData:data];
    
    XCTAssertEqualObjects(event.eventID, @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(event.apiSpaceID, @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(event.name, @"conversation.delete");
    XCTAssertEqualObjects(event.context.createdBy, @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqualObjects(event.conversationID, @"myConversation");
    XCTAssertEqualObjects([[NSDateFormatter comapiFormatter] stringFromDate:event.payload.date], @"2016-10-06T06:45:26.911Z");
    XCTAssertEqual([event.conversationEventID integerValue], 123);
    
    NSDictionary *json = [event json];
    
    XCTAssertEqualObjects(json[@"eventId"], @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(json[@"apiSpaceId"], @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(json[@"name"], @"conversation.delete");
    XCTAssertEqualObjects(json[@"context"][@"createdBy"], @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqualObjects(json[@"conversationId"], @"myConversation");
    XCTAssertEqualObjects(json[@"payload"][@"date"], @"2016-10-06T06:45:26.911Z");
    XCTAssertEqual([json[@"conversationEventId"] integerValue], 123);
}

- (void)testConversationUndelete {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Event.conversation.undelete"];
    
    CMPConversationEventUndelete *event = [CMPConversationEventUndelete decodeWithData:data];
    
    XCTAssertEqualObjects(event.eventID, @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(event.apiSpaceID, @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(event.name, @"conversation.undelete");
    XCTAssertEqualObjects(event.context.createdBy, @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqualObjects(event.conversationID, @"myConversation");
    XCTAssertEqualObjects(event.payload.id, @"myConversation");
    XCTAssertEqualObjects(event.payload.eventDescription, @"myConversationDescription");
    XCTAssertEqualObjects(event.payload.name, @"myConversationName");
    XCTAssertEqual([event.conversationEventID integerValue], 123);
    XCTAssertEqual([event.payload.isPublic boolValue], YES);
    XCTAssertEqual(event.payload.roles.owner.canSend, YES);
    XCTAssertEqual(event.payload.roles.owner.canAddParticipants, NO);
    XCTAssertEqual(event.payload.roles.owner.canRemoveParticipants, YES);
    XCTAssertEqual(event.payload.roles.participant.canSend, YES);
    XCTAssertEqual(event.payload.roles.participant.canAddParticipants, NO);
    XCTAssertEqual(event.payload.roles.participant.canRemoveParticipants, YES);
    
    NSDictionary *json = [event json];
    
    XCTAssertEqualObjects(json[@"eventId"], @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(json[@"apiSpaceId"], @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(json[@"name"], @"conversation.undelete");
    XCTAssertEqualObjects(json[@"context"][@"createdBy"], @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqualObjects(json[@"payload"][@"name"], @"myConversationName");
    XCTAssertEqualObjects(json[@"payload"][@"id"], @"myConversation");
    XCTAssertEqualObjects(json[@"payload"][@"description"], @"myConversationDescription");
    XCTAssertEqual([json[@"conversationEventId"] integerValue], 123);
    XCTAssertEqual([json[@"payload"][@"isPublic"] boolValue], YES);
    XCTAssertEqual([json[@"payload"][@"roles"][@"owner"][@"canSend"] boolValue], YES);
    XCTAssertEqual([json[@"payload"][@"roles"][@"owner"][@"canAddParticipants"] boolValue], NO);
    XCTAssertEqual([json[@"payload"][@"roles"][@"owner"][@"canRemoveParticipants"] boolValue], YES);
    XCTAssertEqual([json[@"payload"][@"roles"][@"participant"][@"canSend"] boolValue], YES);
    XCTAssertEqual([json[@"payload"][@"roles"][@"participant"][@"canAddParticipants"] boolValue], NO);
    XCTAssertEqual([json[@"payload"][@"roles"][@"participant"][@"canRemoveParticipants"] boolValue], YES);
}

- (void)testConversationUpdate {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Event.conversation.update"];
    
    CMPConversationEventUpdate *event = [CMPConversationEventUpdate decodeWithData:data];
    
    XCTAssertEqualObjects(event.eventID, @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(event.apiSpaceID, @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(event.name, @"conversation.update");
    XCTAssertEqualObjects(event.context.createdBy, @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqualObjects(event.conversationID, @"myConversation");
    XCTAssertEqualObjects(event.payload.name, @"myConversationName");
    XCTAssertEqualObjects(event.payload.id, @"myConversation");
    XCTAssertEqualObjects(event.payload.eventDescription, @"myConversationDescription");
    XCTAssertEqual([event.conversationEventID integerValue], 123);
    XCTAssertEqual([event.payload.isPublic boolValue], NO);
    XCTAssertEqual(event.payload.roles.owner.canSend, YES);
    XCTAssertEqual(event.payload.roles.owner.canAddParticipants, NO);
    XCTAssertEqual(event.payload.roles.owner.canRemoveParticipants, YES);
    XCTAssertEqual(event.payload.roles.participant.canSend, YES);
    XCTAssertEqual(event.payload.roles.participant.canAddParticipants, NO);
    XCTAssertEqual(event.payload.roles.participant.canRemoveParticipants, YES);
    
    NSDictionary *json = [event json];
    
    XCTAssertEqualObjects(json[@"eventId"], @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(json[@"apiSpaceId"], @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(json[@"name"], @"conversation.update");
    XCTAssertEqualObjects(json[@"context"][@"createdBy"], @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqualObjects(json[@"payload"][@"name"], @"myConversationName");
    XCTAssertEqualObjects(json[@"payload"][@"id"], @"myConversation");
    XCTAssertEqualObjects(json[@"payload"][@"description"], @"myConversationDescription");
    XCTAssertEqual([json[@"conversationEventId"] integerValue], 123);
    XCTAssertEqual([json[@"payload"][@"isPublic"] boolValue], NO);
    XCTAssertEqual([json[@"payload"][@"roles"][@"owner"][@"canSend"] boolValue], YES);
    XCTAssertEqual([json[@"payload"][@"roles"][@"owner"][@"canAddParticipants"] boolValue], NO);
    XCTAssertEqual([json[@"payload"][@"roles"][@"owner"][@"canRemoveParticipants"] boolValue], YES);
    XCTAssertEqual([json[@"payload"][@"roles"][@"participant"][@"canSend"] boolValue], YES);
    XCTAssertEqual([json[@"payload"][@"roles"][@"participant"][@"canAddParticipants"] boolValue], NO);
    XCTAssertEqual([json[@"payload"][@"roles"][@"participant"][@"canRemoveParticipants"] boolValue], YES);
}

- (void)testConversationParticipantAdded {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Event.conversation.participantAdded"];
    
    CMPConversationEventParticipantAdded *event = [CMPConversationEventParticipantAdded decodeWithData:data];
    
    XCTAssertEqualObjects(event.eventID, @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(event.apiSpaceID, @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(event.name, @"conversation.participantAdded");
    XCTAssertEqualObjects(event.context.createdBy, @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqualObjects(event.conversationID, @"myConversation");
    XCTAssertEqual([event.conversationEventID integerValue], 123);
    XCTAssertEqualObjects(event.payload.profileID, @"myProfile");
    XCTAssertEqualObjects(event.payload.role, @"participant");
    XCTAssertEqualObjects(event.payload.conversationID, @"myConversation");
    XCTAssertEqualObjects(event.payload.apiSpaceID, @"MOCK_API_SPACE_ID");
    
    NSDictionary *json = [event json];
    
    XCTAssertEqualObjects(json[@"eventId"], @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(json[@"apiSpaceId"], @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(json[@"name"], @"conversation.participantAdded");
    XCTAssertEqualObjects(json[@"context"][@"createdBy"], @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqual([json[@"conversationEventId"] integerValue], 123);
    XCTAssertEqualObjects(json[@"payload"][@"profileId"], @"myProfile");
    XCTAssertEqualObjects(json[@"payload"][@"role"], @"participant");
    XCTAssertEqualObjects(json[@"payload"][@"conversationId"], @"myConversation");
    XCTAssertEqualObjects(json[@"payload"][@"apiSpaceId"], @"MOCK_API_SPACE_ID");
}

- (void)testConversationParticipantRemoved {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Event.conversation.participantRemoved"];
    
    CMPConversationEventParticipantRemoved *event = [CMPConversationEventParticipantRemoved decodeWithData:data];
    
    XCTAssertEqualObjects(event.eventID, @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(event.apiSpaceID, @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(event.name, @"conversation.participantRemoved");
    XCTAssertEqualObjects(event.context.createdBy, @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqualObjects(event.conversationID, @"myConversation");
    XCTAssertEqual([event.conversationEventID integerValue], 123);
    XCTAssertEqualObjects(event.payload.profileID, @"myProfile");
    XCTAssertEqualObjects(event.payload.conversationID, @"myConversation");
    XCTAssertEqualObjects(event.payload.apiSpaceID, @"MOCK_API_SPACE_ID");
    
    NSDictionary *json = [event json];
    
    XCTAssertEqualObjects(json[@"eventId"], @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(json[@"apiSpaceId"], @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(json[@"name"], @"conversation.participantRemoved");
    XCTAssertEqualObjects(json[@"context"][@"createdBy"], @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqual([json[@"conversationEventId"] integerValue], 123);
    XCTAssertEqualObjects(json[@"payload"][@"profileId"], @"myProfile");
    XCTAssertEqualObjects(json[@"payload"][@"conversationId"], @"myConversation");
    XCTAssertEqualObjects(json[@"payload"][@"apiSpaceId"], @"MOCK_API_SPACE_ID");
}

- (void)testConversationParticipantUpdate {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Event.conversation.participantUpdated"];
    
    CMPConversationEventParticipantUpdated *event = [CMPConversationEventParticipantUpdated decodeWithData:data];
    
    XCTAssertEqualObjects(event.eventID, @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(event.apiSpaceID, @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(event.name, @"conversation.participantUpdated");
    XCTAssertEqualObjects(event.context.createdBy, @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqualObjects(event.conversationID, @"myConversation");
    XCTAssertEqual([event.conversationEventID integerValue], 123);
    XCTAssertEqualObjects(event.payload.profileID, @"myProfile");
    XCTAssertEqualObjects(event.payload.role, @"participant");
    XCTAssertEqualObjects(event.payload.conversationID, @"myConversation");
    XCTAssertEqualObjects(event.payload.apiSpaceID, @"MOCK_API_SPACE_ID");
    
    NSDictionary *json = [event json];
    
    XCTAssertEqualObjects(json[@"eventId"], @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(json[@"apiSpaceId"], @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(json[@"name"], @"conversation.participantUpdated");
    XCTAssertEqualObjects(json[@"context"][@"createdBy"], @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqual([json[@"conversationEventId"] integerValue], 123);
    XCTAssertEqualObjects(json[@"payload"][@"profileId"], @"myProfile");
    XCTAssertEqualObjects(json[@"payload"][@"role"], @"participant");
    XCTAssertEqualObjects(json[@"payload"][@"conversationId"], @"myConversation");
    XCTAssertEqualObjects(json[@"payload"][@"apiSpaceId"], @"MOCK_API_SPACE_ID");
}

- (void)testConversationMessageDelivered {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Event.conversationMessage.delivered"];
    
    CMPConversationMessageEventDelivered *event = [CMPConversationMessageEventDelivered decodeWithData:data];
    
    XCTAssertEqualObjects(event.eventID, @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(event.apiSpaceID, @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(event.name, @"conversationMessage.delivered");
    XCTAssertEqualObjects(event.context.createdBy, @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqual([event.conversationEventID integerValue], 123);
    XCTAssertEqualObjects(event.payload.profileID, @"myProfile");
    XCTAssertEqualObjects(event.payload.messageID, @"1d8f9efc-159d-49f0-b01b-ce72bc2d23f7");
    XCTAssertEqualObjects(event.payload.conversationID, @"myConversation");
    XCTAssertEqualObjects([[NSDateFormatter comapiFormatter] stringFromDate:event.payload.timestamp], @"2016-10-06T06:45:26.910Z");
    
    NSDictionary *json = [event json];
    
    XCTAssertEqualObjects(json[@"eventId"], @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(json[@"apiSpaceId"], @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(json[@"name"], @"conversationMessage.delivered");
    XCTAssertEqualObjects(json[@"context"][@"createdBy"], @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqual([json[@"conversationEventId"] integerValue], 123);
    XCTAssertEqualObjects(json[@"payload"][@"profileId"], @"myProfile");
    XCTAssertEqualObjects(json[@"payload"][@"messageId"], @"1d8f9efc-159d-49f0-b01b-ce72bc2d23f7");
    XCTAssertEqualObjects(json[@"payload"][@"conversationId"], @"myConversation");
    XCTAssertEqualObjects(json[@"payload"][@"timestamp"], @"2016-10-06T06:45:26.910Z");
}

- (void)testConversationMessageRead {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Event.conversationMessage.read"];
    
    CMPConversationMessageEventRead *event = [CMPConversationMessageEventRead decodeWithData:data];
    
    XCTAssertEqualObjects(event.eventID, @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(event.apiSpaceID, @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(event.name, @"conversationMessage.read");
    XCTAssertEqualObjects(event.context.createdBy, @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqual([event.conversationEventID integerValue], 123);
    XCTAssertEqualObjects(event.payload.profileID, @"myProfile");
    XCTAssertEqualObjects(event.payload.messageID, @"1d8f9efc-159d-49f0-b01b-ce72bc2d23f7");
    XCTAssertEqualObjects(event.payload.conversationID, @"myConversation");
    XCTAssertEqualObjects([[NSDateFormatter comapiFormatter] stringFromDate:event.payload.timestamp], @"2016-10-06T06:45:26.910Z");
    
    NSDictionary *json = [event json];
    
    XCTAssertEqualObjects(json[@"eventId"], @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(json[@"apiSpaceId"], @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(json[@"name"], @"conversationMessage.read");
    XCTAssertEqualObjects(json[@"context"][@"createdBy"], @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqual([json[@"conversationEventId"] integerValue], 123);
    XCTAssertEqualObjects(json[@"payload"][@"profileId"], @"myProfile");
    XCTAssertEqualObjects(json[@"payload"][@"messageId"], @"1d8f9efc-159d-49f0-b01b-ce72bc2d23f7");
    XCTAssertEqualObjects(json[@"payload"][@"conversationId"], @"myConversation");
    XCTAssertEqualObjects(json[@"payload"][@"timestamp"], @"2016-10-06T06:45:26.910Z");
}

- (void)testConversationMessageSent {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Event.conversationMessage.sent"];
    
    CMPConversationMessageEventSent *event = [CMPConversationMessageEventSent decodeWithData:data];
    
    XCTAssertEqualObjects(event.eventID, @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(event.apiSpaceID, @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(event.name, @"conversationMessage.sent");
    XCTAssertEqualObjects(event.context.createdBy, @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqual([event.conversationEventID integerValue], 123);
    XCTAssertEqualObjects(event.payload.metadata[@"id"], @"coolass id");
    XCTAssertEqualObjects(event.payload.messageID, @"1d8f9efc-159d-49f0-b01b-ce72bc2d23f7");
    XCTAssertEqualObjects(event.payload.context.from.id, @"ID:USR/alex.stevens");
    XCTAssertEqualObjects(event.payload.context.from.name, @"NAME:USR/alex.stevens");
    XCTAssertEqualObjects(event.payload.context.conversationID, @"myConversation");
    XCTAssertEqualObjects(event.payload.context.sentBy, @"USR/alex.stevens");
    XCTAssertEqualObjects([[NSDateFormatter comapiFormatter] stringFromDate:event.payload.context.sentOn], @"2016-10-06T06:45:26.502Z");
    XCTAssertEqualObjects(event.payload.parts[0].name, @"PART_NAME");
    XCTAssertEqualObjects(event.payload.parts[0].type, @"image/jpeg");
    XCTAssertEqualObjects(event.payload.parts[0].url.absoluteString, @"http://url.test");
    XCTAssertEqualObjects(event.payload.parts[0].data, @"base64EncodedData");
    XCTAssertEqual(event.payload.parts[0].size.integerValue, 12535);
    XCTAssertEqualObjects(event.payload.alert.platforms.apns[@"apnsKey1"], @"apnsValue1");
    XCTAssertEqualObjects(event.payload.alert.platforms.fcm[@"fcmKey1"], @"fcmValue1");
    
    NSDictionary *json = [event json];
    
    XCTAssertEqualObjects(json[@"eventId"], @"2e611475-e12c-4d2f-9430-1f30cf6b4064");
    XCTAssertEqualObjects(json[@"apiSpaceId"], @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(json[@"name"], @"conversationMessage.sent");
    XCTAssertEqualObjects(json[@"context"][@"createdBy"], @"175f7d6d-9422-466f-9c1b-c6da5c818c4b");
    XCTAssertEqual([json[@"conversationEventId"] integerValue], 123);
    XCTAssertEqualObjects(json[@"payload"][@"metadata"][@"id"], @"coolass id");
    XCTAssertEqualObjects(json[@"payload"][@"messageId"], @"1d8f9efc-159d-49f0-b01b-ce72bc2d23f7");
    XCTAssertEqualObjects(json[@"payload"][@"context"][@"from"][@"id"], @"ID:USR/alex.stevens");
    XCTAssertEqualObjects(json[@"payload"][@"context"][@"from"][@"name"], @"NAME:USR/alex.stevens");
    XCTAssertEqualObjects(json[@"payload"][@"context"][@"conversationId"], @"myConversation");
    XCTAssertEqualObjects(json[@"payload"][@"context"][@"sentBy"], @"USR/alex.stevens");
    XCTAssertEqualObjects(json[@"payload"][@"context"][@"sentOn"], @"2016-10-06T06:45:26.502Z");
    XCTAssertEqualObjects(json[@"payload"][@"parts"][0][@"name"], @"PART_NAME");
    XCTAssertEqualObjects(json[@"payload"][@"parts"][0][@"type"], @"image/jpeg");
    XCTAssertEqualObjects(json[@"payload"][@"parts"][0][@"url"], @"http://url.test");
    XCTAssertEqualObjects(json[@"payload"][@"parts"][0][@"data"], @"base64EncodedData");
    XCTAssertEqual([json[@"payload"][@"parts"][0][@"size"] integerValue], 12535);
    XCTAssertEqualObjects(json[@"payload"][@"alert"][@"platforms"][@"apns"][@"apnsKey1"], @"apnsValue1");
    XCTAssertEqualObjects(json[@"payload"][@"alert"][@"platforms"][@"fcm"][@"fcmKey1"], @"fcmValue1");
}

- (void)testSocketInfo {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Event.socket.info"];
    
    CMPSocketEventInfo *event = [CMPSocketEventInfo decodeWithData:data];
    
    XCTAssertEqual(event.accountID.integerValue, 41590);
    XCTAssertEqualObjects(event.eventID, @"c3485aae-e909-4b18-b67c-e183f7fea210");
    XCTAssertEqualObjects(event.socketID, @"91b8b750-a7fe-4d6d-8d6d-69c130654dc1");
    XCTAssertEqualObjects(event.apiSpaceID, @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(event.name, @"socket.info");
    XCTAssertEqualObjects(event.context.createdBy, @"sub");
    
    NSDictionary *json = [event json];
    
    XCTAssertEqual([json[@"accountId"] integerValue], 41590);
    XCTAssertEqualObjects(json[@"eventId"], @"c3485aae-e909-4b18-b67c-e183f7fea210");
    XCTAssertEqualObjects(json[@"socketId"], @"91b8b750-a7fe-4d6d-8d6d-69c130654dc1");
    XCTAssertEqualObjects(json[@"apiSpaceId"], @"MOCK_API_SPACE_ID");
    XCTAssertEqualObjects(json[@"name"], @"socket.info");
    XCTAssertEqualObjects(json[@"context"][@"createdBy"], @"sub");
}

- (void)testProfileUpdate {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Event.profile.update"];
    
    CMPProfileEventUpdate *event = [CMPProfileEventUpdate decodeWithData:data];
    
    XCTAssertEqualObjects(event.profileID, @"sub");
    XCTAssertEqualObjects(event.eventID, @"9ee00e10-8921-4876-b9d5-936112168ca2");
    XCTAssertEqualObjects(event.apiSpaceID, @"be466e4b-1340-41fc-826e-20445ab658f1");
    XCTAssertEqualObjects(event.name, @"profile.update");
    XCTAssertEqualObjects(event.context.createdBy, @"session:sub");
    XCTAssertNotNil(event.payload);
    
    NSDictionary *json = [event json];
    
    XCTAssertEqualObjects(json[@"profileId"], @"sub");
    XCTAssertEqualObjects(json[@"eventId"], @"9ee00e10-8921-4876-b9d5-936112168ca2");
    XCTAssertEqualObjects(json[@"apiSpaceId"], @"be466e4b-1340-41fc-826e-20445ab658f1");
    XCTAssertEqualObjects(json[@"name"], @"profile.update");
    XCTAssertEqualObjects(json[@"context"][@"createdBy"], @"session:sub");
}

@end
