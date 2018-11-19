//
//  CMPTestComapiClient.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 18/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
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

@interface CMPTestComapiClient : XCTestCase

@property (nonatomic, strong) id<CMPAuthenticationDelegate> delegate;
@property (nonatomic, strong) CMPMockRequestPerformer *requestPerformer;
@property (nonatomic, strong) CMPAPIConfiguration *config;
@property (nonatomic, strong) CMPComapiClient *client;

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
    [self.client.services.session endSessionWithCompletion:^(BOOL result, NSError * error) {
        id self = weakSelf;
        XCTAssertNil(error);
        XCTAssertTrue(result);
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
    [self.client.services.profile getProfileWithProfileID:@"90419e09-1f5b-4fc2-97c8-b878793c53f0" completion:^(CMPProfile * profile, NSError * error) {
        id self = weakSelf;
        XCTAssertNil(error);
        XCTAssertNotNil(profile);
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
    [self.client.services.profile queryProfilesWithQueryElements:@[equalTo] completion:^(NSArray<CMPProfile *> * profiles, NSError * error) {
        id self = weakSelf;
        XCTAssertNil(error);
        XCTAssertNotNil(profiles);
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
    [self.client.services.profile updateProfileWithProfileID:@"90419e09-1f5b-4fc2-97c8-b878793c53f0" attributes:@{@"email" : @"test2@mail.com"} eTag:nil completion:^(CMPProfile * profile, NSError * error) {
        id self = weakSelf;
        XCTAssertNil(error);
        XCTAssertNotNil(profile);
        XCTAssertEqualObjects(profile.email, @"test2@mail.com");
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
    [self.client.services.profile patchProfileWithProfileID:@"90419e09-1f5b-4fc2-97c8-b878793c53f0" attributes:@{@"email" : @"test2@mail.com"} eTag:nil completion:^(CMPProfile * profile, NSError * error) {
            id self = weakSelf;
            XCTAssertNil(error);
            XCTAssertNotNil(profile);
            XCTAssertEqualObjects(profile.email, @"test2@mail.com");
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
    [self.client.services.messaging sendMessage:message toConversationWithID:conversationID completion:^(CMPSendMessagesResult * _Nullable result, NSError * _Nullable error) {
        id self = weakSelf;
        XCTAssertNil(error);
        XCTAssertNotNil(result.id);
        XCTAssertNotNil(result.eventID);
        XCTAssertEqualObjects(result.id, @"MOCK_ID");
        XCTAssertEqualObjects(result.eventID, @(1234));
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
    [self.client.services.messaging getMessagesWithConversationID:conversationID limit:100 from:0 completion:^(CMPGetMessagesResult * _Nullable result, NSError * _Nullable error) {
        id self = weakSelf;
        XCTAssertNil(error);
        XCTAssertEqualObjects(result.latestEventID, @(35));
        XCTAssertEqualObjects(result.earliestEventID, @(34));
        XCTAssertEqual(result.orphanedEvents.count, 0);
        XCTAssertEqual(result.messages.count, 1);
        
        CMPMessage *message = result.messages[0];
        
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
    [self.client.services.messaging getConversationWithConversationID:conversationID completion:^(CMPConversation * _Nullable conversation, NSError * _Nullable error) {
        id self = weakSelf;
        XCTAssertNil(error);
        XCTAssertEqualObjects(conversation.id, @"support");
        XCTAssertEqualObjects(conversation.name, @"Support");
        XCTAssertEqualObjects(conversation.conversationDescription, @"The Support Channel");
        XCTAssertEqual(conversation.roles.owner.canSend, YES);
        XCTAssertEqual(conversation.roles.owner.canAddParticipants, YES);
        XCTAssertEqual(conversation.roles.owner.canRemoveParticipants, YES);
        XCTAssertEqual(conversation.roles.participant.canSend, YES);
        XCTAssertEqual(conversation.roles.participant.canAddParticipants, YES);
        XCTAssertEqual(conversation.roles.participant.canRemoveParticipants, YES);
        XCTAssertEqualObjects(conversation.isPublic, @(NO));
        
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
    [self.client.services.messaging getConversationsWithScope:@"public" profileID:profileID completion:^(NSArray<CMPConversation *> * _Nullable conversations, NSError * _Nullable error) {
        
        id self = weakSelf;
        XCTAssertNil(error);
        
        CMPConversation *c1 = conversations[0];
        CMPConversation *c2 = conversations[1];
        
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
    [self.client.services.messaging addConversationWithConversation:[[CMPNewConversation alloc] init] completion:^(CMPConversation * _Nullable conversation, NSError * _Nullable error) {
        id self = weakSelf;
        XCTAssertNil(error);
        XCTAssertEqualObjects(conversation.id, @"support");
        XCTAssertEqualObjects(conversation.name, @"Support");
        XCTAssertEqualObjects(conversation.conversationDescription, @"The Support Channel");
        XCTAssertEqual(conversation.roles.owner.canSend, YES);
        XCTAssertEqual(conversation.roles.owner.canAddParticipants, YES);
        XCTAssertEqual(conversation.roles.owner.canRemoveParticipants, YES);
        XCTAssertEqual(conversation.roles.participant.canSend, YES);
        XCTAssertEqual(conversation.roles.participant.canAddParticipants, YES);
        XCTAssertEqual(conversation.roles.participant.canRemoveParticipants, YES);
        XCTAssertEqualObjects(conversation.isPublic, @(NO));
        
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
    [self.client.services.messaging updateConversationWithConversationID:conversationID conversation:[[CMPConversationUpdate alloc] init] eTag:nil completion:^(CMPConversation * _Nullable conversation, NSError * _Nullable error) {
        id self = weakSelf;
        XCTAssertNil(error);
        XCTAssertEqualObjects(conversation.id, @"support");
        XCTAssertEqualObjects(conversation.name, @"Support");
        XCTAssertEqualObjects(conversation.conversationDescription, @"The Support Channel");
        XCTAssertEqual(conversation.roles.owner.canSend, YES);
        XCTAssertEqual(conversation.roles.owner.canAddParticipants, YES);
        XCTAssertEqual(conversation.roles.owner.canRemoveParticipants, YES);
        XCTAssertEqual(conversation.roles.participant.canSend, YES);
        XCTAssertEqual(conversation.roles.participant.canAddParticipants, YES);
        XCTAssertEqual(conversation.roles.participant.canRemoveParticipants, YES);
        XCTAssertEqualObjects(conversation.isPublic, @(NO));
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

- (void)testDeleteConversation {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] initWithSessionAndAuth];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]];
    NSString *conversationID = @"MOCK_ID";
    
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:nil response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.messaging deleteConversationWithConversationID:conversationID eTag:nil completion:^(BOOL success, NSError * _Nullable error) {
        id self = weakSelf;
        XCTAssertNil(error);
        XCTAssertTrue(success);
        
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
    [self.client.services.messaging addParticipantsWithConversationID:conversationID participants:@[[[CMPConversationParticipant alloc] init]] completion:^(BOOL success, NSError * _Nullable error) {
        id self = weakSelf;
        XCTAssertNil(error);
        XCTAssertTrue(success);
        
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
    [self.client.services.messaging getParticipantsWithConversationID:conversationID completion:^(NSArray<CMPConversationParticipant *> * result, NSError * _Nullable error) {
        id self = weakSelf;
        XCTAssertNil(error);
        XCTAssertTrue(result.count == 2);
        
        XCTAssertEqualObjects(result[0].id, @"1");
        XCTAssertEqualObjects(result[0].role, @"owner");
        XCTAssertEqualObjects(result[1].id, @"2");
        XCTAssertEqualObjects(result[1].role, @"participant");
        
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
    [self.client.services.messaging removeParticipantsWithConversationID:conversationID participants:@[] completion:^(BOOL success, NSError * _Nullable error) {
        id self = weakSelf;
        XCTAssertNil(error);
        XCTAssertTrue(success);
        
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
    [self.client.services.messaging queryEventsWithConversationID:conversationID limit:100 from:0 completion:^(NSArray<CMPEvent *> * _Nonnull events, NSError * _Nullable error) {
        id self = weakSelf;
        XCTAssertNil(error);
        XCTAssertTrue(events.count == 3);
        
        XCTAssertTrue([events[0] isKindOfClass:CMPConversationMessageEventSent.class]);
        XCTAssertTrue([events[1] isKindOfClass:CMPConversationEventParticipantAdded.class]);
        XCTAssertTrue([events[2] isKindOfClass:CMPConversationEventParticipantTyping.class]);
        
        CMPConversationMessageEventSent *sent = (CMPConversationMessageEventSent *)events[0];
        
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
        
        CMPConversationEventParticipantAdded *added = (CMPConversationEventParticipantAdded *)events[1];
        
        XCTAssertEqualObjects(added.apiSpaceID, @"be466e4b-1340-41fc-826e-20445ab658f1");
        XCTAssertEqualObjects(added.context.createdBy, @"session:sub");
        XCTAssertEqualObjects(added.conversationID, @"new cool convo_sub");
        XCTAssertEqualObjects(added.eventID, @"5674af06-0b36-4864-a3c3-ced498443d7d");
        XCTAssertEqualObjects(added.name, @"conversation.participantAdded");
        XCTAssertEqualObjects(added.payload.apiSpaceID, @"be466e4b-1340-41fc-826e-20445ab658f1");
        XCTAssertEqualObjects(added.payload.conversationID, @"new cool convo_sub");
        XCTAssertEqualObjects(added.payload.profileID, @"sub");
        XCTAssertEqualObjects(added.payload.role, @"owner");
        
        CMPConversationEventParticipantTyping *typing = (CMPConversationEventParticipantTyping *)events[2];
        
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
    [self.client.services.messaging uploadContent:[[CMPContentData alloc] init] folder:@"content" completion:^(CMPContentUploadResult * _Nullable result, NSError * _Nullable error) {
        id self = weakSelf;
        XCTAssertNil(error);
        
        XCTAssertEqualObjects(result.folder, @"content");
        XCTAssertEqualObjects(result.type, @"image/jpeg");
        XCTAssertEqualObjects(result.url.absoluteString, @"https://inttest-content.comapi.com/apispaces/2e7dd112-24f6-422b-bcd4-0f2e91315c0b/content/dc02e4fff450a6306e045f5c26801ce31c3efaeb");
        XCTAssertEqualObjects(result.id, @"123");
        XCTAssertEqual(result.size.integerValue, 3801);
        
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
    [self.client.services.messaging updateStatusForMessagesWithIDs:@[@"id", @"id2"] status:@"read" conversationID:conversationID timestamp:[NSDate date] completion:^(BOOL success, NSError * _Nullable error) {
        id self = weakSelf;
        XCTAssertNil(error);
        XCTAssertTrue(success);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:15.0];
}

@end
