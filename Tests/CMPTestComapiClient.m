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
#import "CMPMockRequestPerformer.h"
#import "CMPMockAuthenticationDelegate.h"
#import "CMPComapiConfig.h"
#import "CMPComapi.h"
#import "CMPProfile.h"
#import "CMPConversationMessageEvents.h"
#import "CMPConversationEvents.h"
#import "NSDateFormatter+CMPUtility.h"

@interface CMPTestComapiClient : XCTestCase

@property (nonatomic, strong) id<CMPAuthenticationDelegate> delegate;
@property (nonatomic, strong) CMPMockRequestPerformer *requestPerformer;
@property (nonatomic, strong) CMPAPIConfiguration *config;
@property (nonatomic, strong) CMPComapiClient *client;

@end

@interface CMPComapiClient ()

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate apiConfiguration:(CMPAPIConfiguration *)configuration;
- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate apiConfiguration:(CMPAPIConfiguration *)configuration requestPerformer:(id<CMPRequestPerforming>)requestPerformer;

@end

@implementation CMPTestComapiClient

- (void)setUp {
    [super setUp];
    
    self.delegate = [[CMPMockAuthenticationDelegate alloc] init];
    self.config = [[CMPAPIConfiguration alloc] initWithScheme:@"https" host:@"stage-api.comapi.com" port:443];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetFileLogs {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    logWithLevel(CMPLogLevelError, @"TEST LOG", nil);
    NSData *logs = [self.client getFileLogs];
    NSString *logsString = [[NSString alloc] initWithData:logs encoding:NSUTF8StringEncoding];
    XCTAssertTrue([logsString containsString:@"TEST LOG"]);
    XCTAssertTrue([logsString containsString:@"ERROR"]);
}

- (void)testSetPushToken {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    CMPMockRequestResult *completionValue = [[CMPMockRequestResult alloc] initWithData:nil response:[NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]] error:nil];
    [self.requestPerformer.completionValues addObject:completionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client setPushToken:@"APNS_TOKEN" completion:^(BOOL success, NSError * error) {
        id self = weakSelf;
        XCTAssertNil(error);
        XCTAssertTrue(success);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testStartSession {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSData *data = [CMPResourceLoader loadJSONWithName:@"SessionAuth"];
    CMPMockRequestResult *completionValue = [[CMPMockRequestResult alloc] initWithData:data response:[NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]] error:nil];
    [self.requestPerformer.completionValues addObject:completionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.session startSessionWithCompletion:^{
        id self = weakSelf;
        XCTAssertEqualObjects(weakSelf.client.profileID, @"dominik.kowalski");
        XCTAssertFalse(weakSelf.client.isSessionSuccessfullyCreated);
        [expectation fulfill];
    } failure:^(NSError * _Nullable error) {
        id self = weakSelf;
        XCTFail();
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testEndSession {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL] statusCode:204 httpVersion:@"HTTP/1.1" headers:@{}];
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:nil response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.session endSessionWithCompletion:^(CMPResult<NSNumber *> * result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertTrue([result.object boolValue]);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testGetProfile {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]];
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Profile"];
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:data response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.profile getProfileWithProfileID:@"90419e09-1f5b-4fc2-97c8-b878793c53f0" completion:^(CMPResult<CMPProfile *> * result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertNotNil(result.object);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testQueryProfile {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]];
    NSData *data = [CMPResourceLoader loadJSONWithName:@"ProfileArray"];
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:data response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    CMPQueryElements *equalTo = [[CMPQueryElements alloc] initWithKey:@"id" element:CMPQueryElementEqual value:@"90419e09-1f5b-4fc2-97c8-b878793c53f0"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.profile queryProfilesWithQueryElements:@[equalTo] completion:^(CMPResult<NSArray<CMPProfile *> *> * result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertNotNil(result.object);
        
        NSArray<CMPProfile *> *profiles = result.object;
        XCTAssertTrue(profiles.count == 1);
        CMPProfile *profile = profiles[0];
        XCTAssertEqualObjects(profile.id, @"90419e09-1f5b-4fc2-97c8-b878793c53f0");
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testUpdateProfile {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]];
    NSData *data = [CMPResourceLoader loadJSONWithName:@"ProfileUpdate"];
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:data response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];

    __weak typeof(self) weakSelf = self;
    [self.client.services.profile updateProfileWithProfileID:@"90419e09-1f5b-4fc2-97c8-b878793c53f0" attributes:@{@"email" : @"test2@mail.com"} eTag:nil completion:^(CMPResult<CMPProfile *> * result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertNotNil(result.object);
        XCTAssertEqualObjects(result.object.email, @"test2@mail.com");
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testPatchProfile {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]];
    NSData *data = [CMPResourceLoader loadJSONWithName:@"ProfileUpdate"];
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:data response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.profile patchProfileWithProfileID:@"90419e09-1f5b-4fc2-97c8-b878793c53f0" attributes:@{@"email" : @"test2@mail.com"} eTag:nil completion:^(CMPResult<CMPProfile *> * result) {
            id self = weakSelf;
            XCTAssertNil(result.error);
            XCTAssertNotNil(result.object);
            XCTAssertEqualObjects(result.object.email, @"test2@mail.com");
            [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testSendMessage {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]];
    NSData *data = [CMPResourceLoader loadJSONWithName:@"SendMessagesResult"];
    CMPSendableMessage *message = [[CMPSendableMessage alloc] init];
    NSString *conversationID = @"MOCK_ID";
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:data response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.messaging sendMessage:message toConversationWithID:conversationID completion:^(CMPResult<CMPSendMessagesResult *> * result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertNotNil(result.object.id);
        XCTAssertNotNil(result.object.eventID);
        XCTAssertEqualObjects(result.object.id, @"MOCK_ID");
        XCTAssertEqualObjects(result.object.eventID, @(1234));
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testGetMessages {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]];
    NSData *data = [CMPResourceLoader loadJSONWithName:@"GetMessagesResult"];
    
    NSString *conversationID = @"MOCK_ID";
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:data response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.messaging getMessagesWithConversationID:conversationID limit:100 from:0 completion:^(CMPResult<CMPGetMessagesResult *> * result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertEqualObjects(result.object.latestEventID, @(35));
        XCTAssertEqualObjects(result.object.earliestEventID, @(34));
        XCTAssertEqual(result.object.orphanedEvents.count, 1);
        XCTAssertEqual(result.object.messages.count, 1);
        
        CMPMessage *message = result.object.messages[0];
        
        XCTAssertEqualObjects(message.id, @"c8ee2dff-fc46-4248-843f-76b6d4b621ca");
        XCTAssertEqualObjects(message.metadata[@"id"], @"metadata id");
        XCTAssertEqualObjects(message.metadata[@"color"], @"red");
        XCTAssertEqualObjects(message.metadata[@"count"], @(3));
        
        CMPMessageContext *context = message.context;
        
        XCTAssertEqualObjects(context.from.id, @"dominik.kowalski");
        XCTAssertEqualObjects(context.from.name, @"dominik.kowalski");
        XCTAssertEqualObjects(context.conversationID, @"support");
        XCTAssertEqualObjects(context.sentBy, @"dominik.kowalski");
        XCTAssertEqualObjects([[NSDateFormatter comapiFormatter] stringFromDate:context.sentOn], @"2016-09-29T09:17:46.534Z");
        
        CMPMessagePart *part = message.parts[0];
        
        XCTAssertEqualObjects(part.name, @"PartName");
        XCTAssertEqualObjects(part.type, @"image/jpeg");
        XCTAssertEqualObjects(part.url.absoluteString, @"apple.com");
        XCTAssertEqualObjects(part.data, @"base64EncodedData");
        XCTAssertEqualObjects(part.size, @(12535));
        
        CMPOrphanedEvent *orphanedEvent = result.object.orphanedEvents[0];
        
        XCTAssertEqualObjects(orphanedEvent.id, @(162));
        XCTAssertEqualObjects(orphanedEvent.data.name, @"delivered");
        XCTAssertEqualObjects(orphanedEvent.data.eventID, @"9f0b6286-1afc-4367-b4dd-ad8be8e22d36");
        XCTAssertEqualObjects(orphanedEvent.data.profileID, @"marcin1");
        XCTAssertEqualObjects(orphanedEvent.data.payload.messageID, @"cbe04573-cf2f-4f8e-bc25-ddbea192ab98");
        XCTAssertEqualObjects(orphanedEvent.data.payload.conversationID, @"marcin1.MeyaBot");
        XCTAssertEqualObjects(orphanedEvent.data.payload.isPublicConversation, @(NO));
        XCTAssertEqualObjects(orphanedEvent.data.payload.profileID, @"marcin1");
        XCTAssertEqualObjects([[NSDateFormatter comapiFormatter] stringFromDate:orphanedEvent.data.payload.timestamp], @"2017-01-10T16:31:27.783Z");

        XCTAssertEqual(message.statusUpdates.count, 0);

        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testGetConversation {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]];
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Conversation"];
    
    NSString *conversationID = @"MOCK_ID";
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:data response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.messaging getConversationWithConversationID:conversationID completion:^(CMPResult<CMPConversation *> * result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertEqualObjects(result.object.id, @"support");
        XCTAssertEqualObjects(result.object.name, @"Support");
        XCTAssertEqualObjects(result.object.conversationDescription, @"The Support Channel");
        XCTAssertEqual(result.object.roles.owner.canSend, YES);
        XCTAssertEqual(result.object.roles.owner.canAddParticipants, YES);
        XCTAssertEqual(result.object.roles.owner.canRemoveParticipants, YES);
        XCTAssertEqual(result.object.roles.participant.canSend, YES);
        XCTAssertEqual(result.object.roles.participant.canAddParticipants, YES);
        XCTAssertEqual(result.object.roles.participant.canRemoveParticipants, YES);
        XCTAssertEqualObjects(result.object.isPublic, @(NO));
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testGetConversationsWithScope {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]];
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Conversations"];
    
    NSString *profileID = @"MOCK_ID";
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:data response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.messaging getConversationsWithProfileID:profileID isPublic:YES completion:^(CMPResult<NSArray<CMPConversation *> *> * result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        
        CMPConversation *c1 = result.object[0];
        CMPConversation *c2 = result.object[1];
        
        XCTAssertEqualObjects(c1.id, @"support1");
        XCTAssertEqualObjects(c1.name, @"Support1");
        XCTAssertEqualObjects(c1.conversationDescription, @"The Support Channel1");
        XCTAssertEqual(c1.roles.owner.canSend, YES);
        XCTAssertEqual(c1.roles.owner.canAddParticipants, YES);
        XCTAssertEqual(c1.roles.owner.canRemoveParticipants, YES);
        XCTAssertEqual(c1.roles.participant.canSend, YES);
        XCTAssertEqual(c1.roles.participant.canAddParticipants, YES);
        XCTAssertEqual(c1.roles.participant.canRemoveParticipants, YES);
        XCTAssertEqualObjects(c1.isPublic, @(NO));
        
        XCTAssertEqualObjects(c2.id, @"support2");
        XCTAssertEqualObjects(c2.name, @"Support2");
        XCTAssertEqualObjects(c2.conversationDescription, @"The Support Channel2");
        XCTAssertEqual(c2.roles.owner.canSend, YES);
        XCTAssertEqual(c2.roles.owner.canAddParticipants, YES);
        XCTAssertEqual(c2.roles.owner.canRemoveParticipants, YES);
        XCTAssertEqual(c2.roles.participant.canSend, YES);
        XCTAssertEqual(c2.roles.participant.canAddParticipants, YES);
        XCTAssertEqual(c2.roles.participant.canRemoveParticipants, YES);
        XCTAssertEqualObjects(c2.isPublic, @(NO));
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testAddConversation {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL] statusCode:201 httpVersion:@"HTTP/1.1" headers:@{}];
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Conversation"];
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:data response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.messaging addConversationWithConversation:[[CMPNewConversation alloc] init] completion:^(CMPResult<CMPConversation *> * result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertEqualObjects(result.object.id, @"support");
        XCTAssertEqualObjects(result.object.name, @"Support");
        XCTAssertEqualObjects(result.object.conversationDescription, @"The Support Channel");
        XCTAssertEqual(result.object.roles.owner.canSend, YES);
        XCTAssertEqual(result.object.roles.owner.canAddParticipants, YES);
        XCTAssertEqual(result.object.roles.owner.canRemoveParticipants, YES);
        XCTAssertEqual(result.object.roles.participant.canSend, YES);
        XCTAssertEqual(result.object.roles.participant.canAddParticipants, YES);
        XCTAssertEqual(result.object.roles.participant.canRemoveParticipants, YES);
        XCTAssertEqualObjects(result.object.isPublic, @(NO));
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testUpdateConversation {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]];
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Conversation"];
    
    NSString *conversationID = @"MOCK_ID";
    
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:data response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.messaging updateConversationWithConversationID:conversationID conversation:[[CMPConversationUpdate alloc] init] eTag:nil completion:^(CMPResult<CMPConversation *> * result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertEqualObjects(result.object.id, @"support");
        XCTAssertEqualObjects(result.object.name, @"Support");
        XCTAssertEqualObjects(result.object.conversationDescription, @"The Support Channel");
        XCTAssertEqual(result.object.roles.owner.canSend, YES);
        XCTAssertEqual(result.object.roles.owner.canAddParticipants, YES);
        XCTAssertEqual(result.object.roles.owner.canRemoveParticipants, YES);
        XCTAssertEqual(result.object.roles.participant.canSend, YES);
        XCTAssertEqual(result.object.roles.participant.canAddParticipants, YES);
        XCTAssertEqual(result.object.roles.participant.canRemoveParticipants, YES);
        XCTAssertEqualObjects(result.object.isPublic, @(NO));
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testDeleteConversation {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL] statusCode:204 httpVersion:@"HTTP/1.1" headers:@{}];
    NSString *conversationID = @"MOCK_ID";
    
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:nil response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.messaging deleteConversationWithConversationID:conversationID eTag:nil completion:^(CMPResult<NSNumber *> * result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertTrue([result.object boolValue]);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testAddParticipantToConversation {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL] statusCode:201 httpVersion:@"HTTP/1.1" headers:@{}];
    NSString *conversationID = @"MOCK_ID";

    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:nil response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.messaging addParticipantsWithConversationID:conversationID participants:@[[[CMPConversationParticipant alloc] init]] completion:^(CMPResult<NSNumber *> * result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertTrue([result.object boolValue]);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testGetParticipantWithConversation {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]];
    NSString *conversationID = @"MOCK_ID";
    NSData *data = [CMPResourceLoader loadJSONWithName:@"ConversationParticipants"];
    
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:data response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.messaging getParticipantsWithConversationID:conversationID completion:^(CMPResult<NSArray<CMPConversationParticipant *> *> * result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertTrue(result.object.count == 2);
        
        XCTAssertEqualObjects(result.object[0].id, @"1");
        XCTAssertEqual(result.object[0].role, CMPRoleOwner);
        XCTAssertEqualObjects(result.object[1].id, @"2");
        XCTAssertEqual(result.object[1].role, CMPRoleParticipant);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testRemoveParticipantFromConversation {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL] statusCode:204 httpVersion:@"HTTP/1.1" headers:@{}];
    NSString *conversationID = @"MOCK_ID";

    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:nil response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.messaging removeParticipantsWithConversationID:conversationID participants:@[] completion:^(CMPResult<NSNumber *> * result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertTrue([result.object boolValue]);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testQueryEventsWithConversation {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]];
    NSString *conversationID = @"MOCK_ID";
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Events"];
    
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:data response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.messaging queryEventsWithConversationID:conversationID limit:100 from:0 completion:^(CMPResult<NSArray<CMPEvent *> *> * result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertTrue(result.object.count == 3);
        
        XCTAssertTrue([result.object[0] isKindOfClass:CMPConversationMessageEventSent.class]);
        XCTAssertTrue([result.object[1] isKindOfClass:CMPConversationEventParticipantAdded.class]);
        XCTAssertTrue([result.object[2] isKindOfClass:CMPConversationEventParticipantTyping.class]);
        
        CMPConversationMessageEventSent *sent = (CMPConversationMessageEventSent *)result.object[0];
        
        XCTAssertEqualObjects(sent.apiSpaceID, @"be466e4b-1340-41fc-826e-20445ab658f1");
        XCTAssertEqualObjects(sent.context.createdBy, @"session:sub");
        XCTAssertEqualObjects(sent.eventID, @"6c5e4883-203c-4475-ba3d-c375172a76c9");
        XCTAssertEqualObjects(sent.name, @"conversationMessage.sent");
        XCTAssertEqualObjects(sent.payload.context.conversationID, @"conv_sub");
        XCTAssertEqualObjects(sent.payload.context.from.id, @"sub");
        XCTAssertEqualObjects(sent.payload.context.sentBy, @"session:sub");
        XCTAssertEqualObjects(sent.payload.messageID, @"1b60daee-e5e4-4186-b7fc-cf29c5865c61");
        XCTAssertEqualObjects(sent.payload.parts[0].data, @"Haha");
        XCTAssertEqualObjects(sent.payload.parts[0].name, @"");
        XCTAssertEqualObjects(sent.payload.parts[0].size, @(8));
        XCTAssertEqualObjects(sent.payload.parts[0].type, @"text/plain");
        XCTAssertEqualObjects(sent.payload.metadata[@"myMessageID"], @(123));
        
        CMPConversationEventParticipantAdded *added = (CMPConversationEventParticipantAdded *)result.object[1];
        
        XCTAssertEqualObjects(added.apiSpaceID, @"be466e4b-1340-41fc-826e-20445ab658f1");
        XCTAssertEqualObjects(added.context.createdBy, @"session:sub");
        XCTAssertEqualObjects(added.conversationID, @"new cool convo_sub");
        XCTAssertEqualObjects(added.eventID, @"5674af06-0b36-4864-a3c3-ced498443d7d");
        XCTAssertEqualObjects(added.name, @"conversation.participantAdded");
        XCTAssertEqualObjects(added.payload.apiSpaceID, @"be466e4b-1340-41fc-826e-20445ab658f1");
        XCTAssertEqualObjects(added.payload.conversationID, @"new cool convo_sub");
        XCTAssertEqualObjects(added.payload.profileID, @"sub");
        XCTAssertEqual(added.payload.role, CMPRoleOwner);
        
        CMPConversationEventParticipantTyping *typing = (CMPConversationEventParticipantTyping *)result.object[2];
        
        XCTAssertEqualObjects(typing.payload.profileID, @"PLATFORMUSER\\dominik.kowalski@comapi.com");
        XCTAssertEqualObjects(typing.payload.conversationID, @"cc089950-bcd8-4344-802a-3d231ad0907c");
        XCTAssertEqualObjects(typing.context.createdBy, @"interactive:dominik.kowalski@comapi.com");
        XCTAssertEqualObjects(typing.eventID, @"2b3fdcbb-4ab4-4b76-a72f-572cd61a5b1a");
        XCTAssertEqual([typing.accountID integerValue], 41590);
        XCTAssertEqualObjects([[NSDateFormatter comapiFormatter] stringFromDate:typing.publishedOn], @"2018-11-08T15:54:38.498Z");
        XCTAssertEqualObjects(typing.name, @"conversation.participantTyping");
        XCTAssertEqualObjects(typing.apiSpaceID, @"be466e4b-1340-41fc-826e-20445ab658f1");
        
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testUploadContent {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]];
    NSData *data = [CMPResourceLoader loadJSONWithName:@"ContentUploadResult"];
    
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:data response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.messaging uploadContent:[[CMPContentData alloc] init] folder:@"content" completion:^(CMPResult<CMPContentUploadResult *> * result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        
        XCTAssertEqualObjects(result.object.folder, @"content");
        XCTAssertEqualObjects(result.object.type, @"image/jpeg");
        XCTAssertEqualObjects(result.object.url.absoluteString, @"https://inttest-content.comapi.com/apispaces/2e7dd112-24f6-422b-bcd4-0f2e91315c0b/content/dc02e4fff450a6306e045f5c26801ce31c3efaeb");
        XCTAssertEqualObjects(result.object.id, @"123");
        XCTAssertEqual(result.object.size.integerValue, 3801);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testUpdateStatusForMessages {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]];
    NSString *conversationID = @"MOCK_ID";
    
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:nil response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.messaging updateStatusForMessagesWithIDs:@[@"id", @"id2"] status:CMPMessageDeliveryStatusDelivered conversationID:conversationID timestamp:[NSDate date] completion:^(CMPResult<NSNumber *> * result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertTrue([result.object boolValue]);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testParticipantIsTyping {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL] statusCode:204 httpVersion:@"HTTP/1.1" headers:@{}];
    NSString *conversationID = @"MOCK_ID";
    
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:nil response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.messaging participantIsTypingWithConversationID:conversationID isTyping:YES completion:^(CMPResult<NSNumber *> * result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertTrue([result.object boolValue]);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

@end
