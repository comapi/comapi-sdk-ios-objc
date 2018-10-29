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
    [self.client.services.profile getProfileForProfileID:@"90419e09-1f5b-4fc2-97c8-b878793c53f0" completion:^(CMPProfile * profile, NSError * error) {
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
    [self.client.services.profile updateProfileForProfileID:@"90419e09-1f5b-4fc2-97c8-b878793c53f0" attributes:@{@"email" : @"test2@mail.com"} eTag:nil completion:^(CMPProfile * profile, NSError * error) {
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
    [self.client.services.profile patchProfileForProfileID:@"90419e09-1f5b-4fc2-97c8-b878793c53f0" attributes:@{@"email" : @"test2@mail.com"} eTag:nil completion:^(CMPProfile * profile, NSError * error) {
            id self = weakSelf;
            XCTAssertNil(error);
            XCTAssertNotNil(profile);
            XCTAssertEqualObjects(profile.email, @"test2@mail.com");
            [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:15.0];
}


@end
