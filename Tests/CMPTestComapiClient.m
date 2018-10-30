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
        XCTAssertEqual(conversation.roles.participants.canSend, YES);
        XCTAssertEqual(conversation.roles.participants.canAddParticipants, YES);
        XCTAssertEqual(conversation.roles.participants.canRemoveParticipants, YES);
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
        XCTAssertEqual(c1.roles.participants.canSend, YES);
        XCTAssertEqual(c1.roles.participants.canAddParticipants, YES);
        XCTAssertEqual(c1.roles.participants.canRemoveParticipants, YES);
        XCTAssertEqualObjects(c1.isPublic, @(NO));
        
        XCTAssertEqualObjects(c2.id, @"support2");
        XCTAssertEqualObjects(c2.name, @"Support2");
        XCTAssertEqualObjects(c2.conversationDescription, @"The Support Channel2");
        XCTAssertEqual(c2.roles.owner.canSend, YES);
        XCTAssertEqual(c2.roles.owner.canAddParticipants, YES);
        XCTAssertEqual(c2.roles.owner.canRemoveParticipants, YES);
        XCTAssertEqual(c2.roles.participants.canSend, YES);
        XCTAssertEqual(c2.roles.participants.canAddParticipants, YES);
        XCTAssertEqual(c2.roles.participants.canRemoveParticipants, YES);
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
        XCTAssertEqual(conversation.roles.participants.canSend, YES);
        XCTAssertEqual(conversation.roles.participants.canAddParticipants, YES);
        XCTAssertEqual(conversation.roles.participants.canRemoveParticipants, YES);
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
        XCTAssertEqual(conversation.roles.participants.canSend, YES);
        XCTAssertEqual(conversation.roles.participants.canAddParticipants, YES);
        XCTAssertEqual(conversation.roles.participants.canRemoveParticipants, YES);
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

@end
