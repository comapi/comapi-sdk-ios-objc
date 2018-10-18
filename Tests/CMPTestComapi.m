//
//  CMPTestComapi.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 18/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPTestMocks.h"
#import "CMPComapi.h"
#import "CMPMockAuthenticationDelegate.h"

@interface CMPTestComapi : XCTestCase

@property (nonatomic, strong) id<CMPAuthenticationDelegate> delegate;
@property (nonatomic, strong) CMPComapiConfig *config;

@end

@implementation CMPTestComapi

- (void)setUp {
    [super setUp];
    
    self.delegate = [[CMPMockAuthenticationDelegate alloc] init];
    self.config = [[CMPComapiConfig alloc] initWithApiSpaceID:[CMPTestMocks mockApiSpaceID] authenticationDelegate:self.delegate];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitialiseWithConfig {
    CMPComapiClient *client = [CMPComapi initialiseWithConfig:self.config];
    
    XCTAssertNotNil(client);
}

- (void)testInitialiseSharedInstanceWithConfig {
    CMPComapiClient *client = [CMPComapi initialiseSharedInstanceWithConfig:self.config];
    
    XCTAssertNotNil(client);
    XCTAssertNotNil([CMPComapi shared]);
}

@end
