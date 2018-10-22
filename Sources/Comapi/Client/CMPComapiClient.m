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

#import "CMPComapiClient.h"
#import "CMPSessionManager.h"
#import "CMPServices.h"
#import "CMPSetAPNSDetailsTemplate.h"

@interface CMPComapiClient ()

@property (nonatomic, copy) NSString *apiSpaceID;

@property (nonatomic, strong) CMPRequestManager *requestManager;
@property (nonatomic, strong) CMPSessionManager *sessionManager;
@property (nonatomic, strong) CMPAPIConfiguration *apiConfiguration;

@property (nonatomic, strong) id<CMPRequestPerforming> requestPerformer;

@end

@implementation CMPComapiClient

-(instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate apiConfiguration:(CMPAPIConfiguration *)configuration {
    self = [self initWithApiSpaceID:apiSpaceID authenticationDelegate:delegate apiConfiguration:configuration requestPerformer:[[CMPRequestPerformer alloc] init]];
    return self;
}

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate apiConfiguration:(CMPAPIConfiguration *)configuration requestPerformer:(id<CMPRequestPerforming>)requestPerformer {
    self = [super init];
    
    if (self) {
        _state = CMPSDKStateInitialising;
        
        self.apiConfiguration = configuration;
        self.apiSpaceID = apiSpaceID;
        self.requestPerformer = requestPerformer;
        
        self.requestManager = [[CMPRequestManager alloc] initWithRequestPerformer:self.requestPerformer];
        self.requestManager.delegate = self;
        
        self.sessionManager = [[CMPSessionManager alloc] initWithApiSpaceID:apiSpaceID authenticationDelegate:delegate requestManager:self.requestManager];
        [self.sessionManager bindClient:self];
        
        _services = [[CMPServices alloc] initWithApiSpaceID:apiSpaceID apiConfiguration:configuration requestManager:self.requestManager sessionAuthProvider:self.sessionManager];
        
        _state = CMPSDKStateInitilised;
    }
    
    return self;
}

- (NSString *)getProfileID {
    return self.sessionManager.sessionAuth.session.profileID;
}

- (BOOL)isSessionSuccessfullyCreated {
    return [self.sessionManager isSessionValid];
}

- (void)setPushToken:(NSString *)deviceToken completion:(void (^)(BOOL, NSError *))completion {
    CMPSetAPNSDetailsTemplate *(^builder)(NSString *) = ^(NSString *token) {
        NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
        NSString *environment = @"";
        
        #if DEBUG
            environment = @"development";
        #else
            environment = @"production";
        #endif
        
        CMPAPNSDetails *details = [[CMPAPNSDetails alloc] initWithBundleID:bundleID environment:environment token:deviceToken];
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
