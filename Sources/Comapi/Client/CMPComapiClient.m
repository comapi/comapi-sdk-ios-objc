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
@property (nonatomic, strong) CMPRequestPerformer *requestPerformer;
@property (nonatomic, strong) CMPAPIConfiguration *apiConfiguration;
@property (nonatomic, strong) CMPSessionManager *sessionManager;

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
    return self.sessionManager.sessionAuth.session.profileId;
}

-(BOOL)isSessionSuccessfullyCreated {
    return [self.sessionManager isSessionValid];
}
//public var profileId: String? {
//    return self.sessionManager.sessionAuth?.sessionInfo.profileId
//}
//
//public var sdkState: SDKState {
//    return self.state
//}
//
//public var services: ServiceContainer {
//    return self.serviceContainer
//}
//
//public var isSessionSuccessfullyCreated: Bool {
//    return self.sessionManager.isSessionValid
//}
//
//public func addEventDelegate(_ delegate: EventListener) {
//    self.socketManager.addEventDelegate(delegate)
//}
//
//public func removeEventDelegate(_ delegate: EventListener) {
//    self.socketManager.removeEventDelegate(delegate)
//}
/*// MARK: Push
 public func setPushToken(_ apnsToken: String, completion: @escaping (Result<Bool, NSError>) -> Void) {
 
 let builder = { (token: String) -> SetAPNSDetailsTemplate in
 
 let bundleIdentifier = Bundle.main.bundleIdentifier
 var environment = ""
 #if DEBUG
 environment = "development"
 #else
 environment = "production"
 #endif
 
 let apnsDetails = SetAPNSDetailsTemplate.Body.APNSDetails(bundleID: bundleIdentifier,
 environment: environment,
 token: apnsToken)
 let body = SetAPNSDetailsTemplate.Body(apns: apnsDetails)
 
 return SetAPNSDetailsTemplate(scheme: self.apiConfiguration.scheme,
 host: self.apiConfiguration.host,
 port: self.apiConfiguration.port,
 apiSpaceId: self.apiSpaceId,
 sessionID: self.sessionManager.sessionAuth?.sessionInfo.id ?? "",
 body: body,
 token: token)
 }
 
 */

-(void)setPushToken:(NSString *)token completion:(void (^)(BOOL, NSError *))completion {
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSString *environment = @"";
    
#if DEBUG
    environment = @"development";
#else
    environment = @"production";
#endif
    
    CMPAPNSDetails *details = [[CMPAPNSDetails alloc] initWithBundleID:bundleID environment:environment token:token];
    CMPAPNSDetailsBody *body = [[CMPAPNSDetailsBody alloc] initWithAPNSDetails:details];
    
    CMPSetAPNSDetailsTemplate *template = [[CMPSetAPNSDetailsTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID token:token sessionID:self.sessionManager.sessionAuth.session.id body:body];
    [template performWithRequestPerformer:self.requestPerformer result:^(CMPRequestTemplateResult * result) {
        BOOL success = [(NSNumber *)result.object boolValue];
        completion(success, result.error);
    }];
}

- (void)requestManagerNeedsToken:(CMPRequestManager *)requestManager {
    [self.sessionManager authenticateWithSuccess:nil failure:nil];
}

@end
