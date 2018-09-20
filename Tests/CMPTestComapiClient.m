//
//  CMPTestComapiClient.m
//  comapi_ios_sdk_objective_c_tests
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
    self.requestPerformer = [[CMPMockRequestPerformer alloc] init];
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
    
    [self waitForExpectations:@[expectation] timeout:5.0];
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
    
    [self waitForExpectations:@[expectation] timeout:5.0];
}

- (void)testEndSession {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] init];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL] statusCode:204 httpVersion:@"HTTP/1.1" headers:@{}];
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:nil response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.session endSessionWithCompletion:^(CMPRequestTemplateResult * _Nonnull result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertTrue([(NSNumber *)result.object boolValue]);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:5.0];
}

- (void)testGetProfile {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] init];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]];
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Profile"];
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:data response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.profile getProfileForProfileID:@"90419e09-1f5b-4fc2-97c8-b878793c53f0" completion:^(CMPRequestTemplateResult * _Nonnull result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertTrue([result.object isKindOfClass:CMPProfile.class]);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:5.0];
}

- (void)testQueryProfile {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] init];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]];
    NSData *data = [CMPResourceLoader loadJSONWithName:@"ProfileArray"];
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:data response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    CMPQueryElements *equalTo = [[CMPQueryElements alloc] initWithKey:@"id" element:CMPQueryElementEqual value:@"90419e09-1f5b-4fc2-97c8-b878793c53f0"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.profile queryProfilesWithQueryElements:@[equalTo] completion:^(CMPRequestTemplateResult * _Nonnull result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertTrue([result.object isKindOfClass:NSArray.class]);
        NSArray<CMPProfile *> *array = result.object;
        XCTAssertTrue(array.count == 1);
        CMPProfile *profile = array[0];
        XCTAssertEqualObjects(profile.id, @"90419e09-1f5b-4fc2-97c8-b878793c53f0");
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:5.0];
}

- (void)testUpdateProfile {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] init];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]];
    NSData *data = [CMPResourceLoader loadJSONWithName:@"ProfileUpdate"];
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:data response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];

    __weak typeof(self) weakSelf = self;
    [self.client.services.profile updateProfileForProfileID:@"90419e09-1f5b-4fc2-97c8-b878793c53f0" attributes:@{@"email" : @"test2@mail.com"} eTag:nil completion:^(CMPRequestTemplateResult * _Nonnull result) {
        id self = weakSelf;
        XCTAssertNil(result.error);
        XCTAssertTrue([result.object isKindOfClass:CMPProfile.class]);
        CMPProfile *profile = result.object;
        XCTAssertEqualObjects(profile.email, @"test2@mail.com");
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:5.0];
}

- (void)testPatchProfile {
    self.requestPerformer = [[CMPMockRequestPerformer alloc] init];
    self.client = [[CMPComapiClient alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate apiConfiguration:self.config requestPerformer:self.requestPerformer];
    
    NSHTTPURLResponse *response = [NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]];
    NSData *data = [CMPResourceLoader loadJSONWithName:@"ProfileUpdate"];
    CMPMockRequestResult *endSessionCompletionValue = [[CMPMockRequestResult alloc] initWithData:data response:response error:nil];
    [self.requestPerformer.completionValues addObject:endSessionCompletionValue];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"callback received"];
    
    __weak typeof(self) weakSelf = self;
    [self.client.services.profile patchProfileForProfileID:@"90419e09-1f5b-4fc2-97c8-b878793c53f0" attributes:@{@"email" : @"test2@mail.com"} eTag:nil completion:^(CMPRequestTemplateResult * _Nonnull result) {
            id self = weakSelf;
            XCTAssertNil(result.error);
            XCTAssertTrue([result.object isKindOfClass:CMPProfile.class]);
            CMPProfile *profile = result.object;
            XCTAssertEqualObjects(profile.email, @"test2@mail.com");
            [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:5.0];
}


@end
