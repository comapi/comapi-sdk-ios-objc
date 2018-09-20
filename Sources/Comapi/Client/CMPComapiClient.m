//
//  CMPClient.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPComapiClient.h"
#import "CMPSessionManager.h"
#import "CMPServices.h"
#import "CMPSetAPNSDetailsTemplate.h"

@interface CMPComapiClient ()

@property (nonatomic, strong) NSString *apiSpaceID;
@property (nonatomic, strong) CMPRequestManager *requestManager;
@property (nonatomic, strong) id<CMPRequestPerforming> requestPerformer;
@property (nonatomic, strong) CMPAPIConfiguration *apiConfiguration;
@property (nonatomic, strong) CMPSessionManager *sessionManager;

@end

@implementation CMPComapiClient

-(instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate apiConfiguration:(CMPAPIConfiguration *)configuration {
    self = [self initWithApiSpaceID:apiSpaceID authenticationDelegate:delegate apiConfiguration:configuration requestPerformer:[[CMPRequestPerformer alloc] init]];
    return self;
}

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate apiConfiguration:(CMPAPIConfiguration *)configuration requestPerformer:(id<CMPRequestPerforming>)requestPerformer {
    self = [super init];
    
    if (self) {
        self.state = CMPSDKStateInitialising;
        
        self.apiConfiguration = configuration;
        self.apiSpaceID = apiSpaceID;
        self.requestPerformer = requestPerformer;
        
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
    return self.sessionManager.sessionAuth.session.profileId;
}

-(BOOL)isSessionSuccessfullyCreated {
    return [self.sessionManager isSessionValid];
}

-(void)setPushToken:(NSString *)token completion:(void (^)(BOOL, NSError *))completion {
    CMPSetAPNSDetailsTemplate *(^builder)(NSString *) = ^(NSString *token) {
        NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
        NSString *environment = @"";
        
        #if DEBUG
            environment = @"development";
        #else
            environment = @"production";
        #endif
        
        CMPAPNSDetails *details = [[CMPAPNSDetails alloc] initWithBundleID:bundleID environment:environment token:token];
        CMPAPNSDetailsBody *body = [[CMPAPNSDetailsBody alloc] initWithAPNSDetails:details];
        NSString *sessionId = self.sessionManager.sessionAuth.session.id != nil ? self.sessionManager.sessionAuth.session.id : @"";
        return [[CMPSetAPNSDetailsTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID token:token sessionID:sessionId body:body];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPRequestTemplateResult * result) {
        BOOL success = [(NSNumber *)result.object boolValue];
        completion(success, result.error);
    }];
}

- (void)requestManagerNeedsToken:(CMPRequestManager *)requestManager {
    [self.sessionManager authenticateWithSuccess:nil failure:nil];
}

@end
