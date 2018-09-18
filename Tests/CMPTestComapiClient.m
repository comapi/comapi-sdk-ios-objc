//
//  CMPTestComapiClient.m
//  comapi_ios_sdk_objective_c_tests
//
//  Created by Dominik Kowalski on 18/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPTestMocks.h"
#import "CMPComapiConfig.h"
#import "CMPComapi.h"

@interface CMPTestComapiClient : XCTestCase

@property (nonatomic, strong) id<CMPAuthenticationDelegate> delegate;
@property (nonatomic, strong) CMPComapiConfig *config;

@end

@implementation CMPTestComapiClient

- (void)setUp {
    [super setUp];
    
    self.delegate = [[CMPMockAuthenticationDelegate alloc] init];
    self.config = [[CMPComapiConfig alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testProfileId {
    NSError *error = nil;
    CMPComapiClient *client = [CMPComapi initialiseWithConfig:self.config error:&error];
    if (error) {
        XCTFail();
    }
}


@end
