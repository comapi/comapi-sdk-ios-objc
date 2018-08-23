//
//  CMPClient.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPComapiClient.h"
#import "CMPRequestManager.h"
#import "CMPSessionManager.h"

@interface CMPComapiClient ()

@property (nonatomic, strong) NSString *apiSpaceID;
@property (nonatomic, strong) CMPRequestManager *requestManager;
@property (nonatomic, strong) CMPRequestPerformer *requestPerformer;
@property (nonatomic, strong) CMPAPIConfiguration *apiConfiguration;
@property (nonatomic, strong) CMPSessionManager *sessionManager;

//@property (nonatomic, strong) NSString* apiSpaceID;
//@property (nonatomic, strong) NSString* apiSpaceID;

@end

@implementation CMPComapiClient

-(instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate apiConfiguration:(CMPAPIConfiguration *)configuration {
    self = [super init];
    
    if (self) {
        self.state = CMPSDKStateInitialising;
        
        self.apiConfiguration = configuration;
        self.apiSpaceID = apiSpaceID;

        self.requestPerformer = [[CMPRequestPerformer alloc] init];
        self.requestManager = [[CMPRequestManager alloc] initWithRequestPerformer:self.requestPerformer];
        self.sessionManager = [[CMPSessionManager alloc] initWithApiSpaceID:apiSpaceID authenticationDelegate:delegate requestManager:self.requestManager];
        self.services = [[CMPServices alloc] initWithApiSpaceID:apiSpaceID apiConfiguration:configuration requestManager:self.requestManager sessionAuthProvider:self.sessionManager];
        
        self.requestManager.delegate = self;
        [self.sessionManager bindClient:self];
        
        self.state = CMPSDKStateInitilised;
    }
    
    return self;
}

- (NSString *)profileID {
    return self.sessionManager
}

-(void)setPushToken:(NSString *)token completion:(void (^)(BOOL, NSError *))completion {
    
}

- (void)requestManagerNeedsToken:(CMPRequestManager *)requestManager {
    self
}

@end
