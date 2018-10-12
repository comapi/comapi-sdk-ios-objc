//
//  CMPClient.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPComapiClient.h"
#import "CMPSessionManager.h"
#import "CMPSocketManager.h"
#import "CMPServices.h"
#import "CMPSetAPNSDetailsTemplate.h"

@interface CMPComapiClient ()

@property (nonatomic, copy) NSString *apiSpaceID;

@property (nonatomic, strong) CMPRequestManager *requestManager;
@property (nonatomic, strong) CMPSessionManager *sessionManager;
@property (nonatomic, strong) CMPSocketManager *socketManager;
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
        
        self.socketManager = [[CMPSocketManager alloc] initWithApiSpaceID:apiSpaceID apiConfiguration:configuration sessionAuthProvider:self.sessionManager];
        
        [self.sessionManager bindClient:self];
        [self.socketManager bindClient:self];
        [self.sessionManager bindSocketManager:self.socketManager];
        
        _services = [[CMPServices alloc] initWithApiSpaceID:apiSpaceID apiConfiguration:configuration requestManager:self.requestManager sessionAuthProvider:self.sessionManager];
        
        _state = CMPSDKStateInitilised;
    }
    
    return self;
}

- (void)addEventDelegate:(id<CMPEventDelegate>)delegate {
    [self.socketManager addEventDelegate:delegate];
}

- (void)removeEventDelegate:(id<CMPEventDelegate>)delegate {
    [self.socketManager removeEventDelegate:delegate];
}

- (NSString *)getProfileID {
    return self.sessionManager.sessionAuth.session.profileId;
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

//import Foundation
//import SwiftWebSocket
//import Result
//
//public protocol EventListener: class {
//    func client(client: ComapiClient, didReceiveEvent event: Event)
//}
//
//public final class ComapiClient {
//
//    private let apiSpaceId: String
//    private let requestManager: RequestManager
//    private let requestTemplatePerformer: RequestTemplatePerforming
//    private let apiConfiguration: APIConfiguration
//    private let serviceContainer: ServiceContainer
//    private let socketManager: SocketManager
//    internal var state: SDKState = .notInitilised {
//        didSet {
//            if state == .sessionActive {
//                self.services.profile.currentProfileId = self.profileId
//            }
//        }
//    }
//
//    fileprivate let sessionManager: SessionManager
//
//    public init(apiSpaceId: String,
//                authenticationDelegate: AuthenticationDelegate?,
//                requestPerformer: RequestPerforming = RequestPerformer(),
//                apiConfiguration: APIConfiguration = .production) {
//        self.state = .initialising
//        self.apiConfiguration = apiConfiguration
//        self.apiSpaceId = apiSpaceId
//
//        let requestTemplatePerformer = RequestTemplatePerformer(requestPerformer: requestPerformer)
//        self.requestTemplatePerformer = requestTemplatePerformer
//        self.requestManager = RequestManager(requestTemplatePerformer: requestTemplatePerformer)
//        self.sessionManager = SessionManager(apiSpaceId: apiSpaceId,
//                                             authenticationDelegate: authenticationDelegate,
//                                             requestManager: self.requestManager)
//        self.serviceContainer = ServiceContainer(apiSpaceId: apiSpaceId,
//                                                 apiConfiguration: apiConfiguration,
//                                                 requestManager: self.requestManager,
//                                                 sessionAuthProvider: self.sessionManager)
//        self.socketManager = SocketManager(apiSpaceId: apiSpaceId,
//                                           apiConfiguration: apiConfiguration,
//                                           sessionAuthProvider: self.sessionManager)
//
//
//        self.requestManager.delegate = self
//        self.socketManager.setClient(client: self)
//        self.sessionManager.setDependencies(socketManager: self.socketManager, client: self)
//        self.state = .initialised
//    }
//
//    public var profileId: String? {
//        return self.sessionManager.sessionAuth?.sessionInfo.profileId
//    }
//
//    public var sdkState: SDKState {
//        return self.state
//    }
//
//    public var services: ServiceContainer {
//        return self.serviceContainer
//    }
//
//    public var isSessionSuccessfullyCreated: Bool {
//        return self.sessionManager.isSessionValid
//    }
//
//    public func addEventDelegate(_ delegate: EventListener) {
//        self.socketManager.addEventDelegate(delegate)
//    }
//
//    public func removeEventDelegate(_ delegate: EventListener) {
//        self.socketManager.removeEventDelegate(delegate)
//    }
//
//    // MARK: Push
//    public func setPushToken(_ apnsToken: String, completion: @escaping (Result<Bool, NSError>) -> Void) {
//
//        let builder = { (token: String) -> SetAPNSDetailsTemplate in
//
//            let bundleIdentifier = Bundle.main.bundleIdentifier
//            var environment = ""
//#if DEBUG
//            environment = "development"
//#else
//            environment = "production"
//#endif
//
//            let apnsDetails = SetAPNSDetailsTemplate.Body.APNSDetails(bundleID: bundleIdentifier,
//                                                                      environment: environment,
//                                                                      token: apnsToken)
//            let body = SetAPNSDetailsTemplate.Body(apns: apnsDetails)
//
//            return SetAPNSDetailsTemplate(scheme: self.apiConfiguration.scheme,
//                                          host: self.apiConfiguration.host,
//                                          port: self.apiConfiguration.port,
//                                          apiSpaceId: self.apiSpaceId,
//                                          sessionID: self.sessionManager.sessionAuth?.sessionInfo.id ?? "",
//                                          body: body,
//                                          token: token)
//        }
//
//        self.requestManager.performUsing(templateBuilder: builder) { (result) in
//            completion(result.map { $0.parsedResult }.mapError { $0 as NSError })
//        }
//    }
//    }
//
//    extension ComapiClient : RequestManagerDelegate {
//        internal func requestManagerNeedsToken(requestManager: RequestManager) {
//            self.sessionManager.authenticate()
//        }
//    }
//
//    extension ComapiClient {
//        public enum SDKState {
//        case notInitilised
//        case initialising
//        case initialised
//        case sessionOff
//        case sessionStarting
//        case sessionActive
//        }
//    }
