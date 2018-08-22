//
//  SessionManager.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 14/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSessionManager.h"
#import "CMPSession.h"
#import "CMPComapiClient.h"
#import "CMPAuthenticationDelegate.h"
#import "CMPKeychain.h"

NSString *const authTokenKeychainItemNamePrefix = @"ComapiSessionToken_";
NSString *const sessionDetailsUserDefaultsPrefix = @"ComapiSessionDetails_";

@interface CMPSessionManager ()

@property (nonatomic, strong, nullable) CMPComapiClient *client;
@property (nonatomic, strong, nullable) CMPSessionAuth *sessionAuth;
@property (nonatomic, strong) CMPRequestManager *requestManager;

@property (nonatomic, weak, nullable) id<CMPAuthenticationDelegate> authenticationDelegate;
@property (nonatomic, copy, nullable) void(^didFinishAuthentication)(void);
@property (nonatomic, copy, nullable) void(^didFailAuthentication)(NSError *);

@property (nonatomic, strong, nonnull) NSString* apiSpaceID;
@property (nonatomic, strong, nonnull) NSString* tokenKey;
@property (nonatomic, strong, nonnull) NSString* detailsKey;

- (void)loadSessionInfo;
- (void)saveSessionInfo;

@end

@implementation CMPSessionManager

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate requestManager:(CMPRequestManager *)requestManager {
    self = [super init];
    if (self) {
        self.apiSpaceID = apiSpaceID;
        self.authenticationDelegate = delegate;
        self.requestManager = requestManager;
    }
    return self;
}

- (BOOL)isSessionValid {
    if (self.sessionAuth != nil && self.sessionAuth.session != nil && self.sessionAuth.session.expiresOn != nil) {
        return self.sessionAuth.session.isActive && [self.sessionAuth.session.expiresOn compare:[NSDate date]] == NSOrderedDescending;
    }
    
    return false;
}

- (void)bindClient:(CMPComapiClient *)client {
    self.client = client;
}

- (void)loadSessionInfo {
    if ([CMPKeychain loadItemForKey:self.tokenKey] == nil || [[NSUserDefaults standardUserDefaults] objectForKey:self.detailsKey] == nil) {
        self.sessionAuth = nil;
        return;
    }
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:self.detailsKey];
    CMPSession *session = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *token = [CMPKeychain loadItemForKey:self.tokenKey];
    if (token && session) {
        CMPSessionAuth *sessionAuth = [[CMPSessionAuth alloc] initWithToken:token session:session];
        self.sessionAuth = sessionAuth;
        [self.requestManager updateToken:token];
    }
}

- (void)saveSessionInfo {
    
}


- (void)authenticateWithSuccess:(void (^ _Nullable)(void))success failure:(void (^ _Nullable)(NSError * _Nonnull))failure {
    <#code#>
}

- (void)authenticationFailedWithError:(nonnull NSError *)error {
    <#code#>
}

- (void)authenticationFinishedWithSessionAuth:(nonnull CMPSessionAuth *)sessionAuth {
    <#code#>
}

- (void)handleAuthenticationChallenge:(nonnull CMPAuthenticationChallenge *)challenge {
    <#code#>
}

@end


/*
 import Foundation
 import SwiftKeychainWrapper
 
 private let authTokenKeychainItemNamePrefix = "ComapiSessionToken_"
 private let sessionDetailsUserDefaultsPrefix = "ComapiSessionDetails_"
 
 internal protocol SessionAuthProvider: class {
 var sessionAuth: SessionAuth? { get }
 
 func authenticate(_ onAuthenticationFinished: (()->())?, _ onAuthenticationFailed: ((Error)->())?)
 }
 
 internal extension SessionAuthProvider {
 func authenticate(onAuthenticationFinished: (()->())? = nil, onAuthenticationFailed: ((Error)->())? = nil) {
 return authenticate(onAuthenticationFinished, onAuthenticationFailed)
 }
 }
 
 internal protocol AuthChallengeHandler: class{
 func handleAuthenticationChallenge(_ challenge: AuthenticationChallenge)
 func authenticationFailed(with error: Error)
 func authenticationFinished(with sessionAuth: SessionAuth)
 }
 
 internal final class SessionManager : SessionAuthProvider {
 internal var sessionAuth: SessionAuth?
 fileprivate weak var authenticationDelegate: AuthenticationDelegate?
 fileprivate weak var socketManager: SocketManager?
 fileprivate weak var client: ComapiClient?
 fileprivate let requestManager: RequestManager
 fileprivate var onAuthenticationFinished: (()->())?
 fileprivate var onAuthenticationFailed: ((Error)->())?
 private let apiSpaceId: String
 private let tokenKey: String
 private let detailsKey: String
 
 internal var isSessionValid: Bool {
 guard let session = self.sessionAuth?.sessionInfo else { return false }
 return session.isActive && session.expiresOn > Date()
 }
 
 init(apiSpaceId: String, authenticationDelegate: AuthenticationDelegate?, requestManager: RequestManager){
 self.authenticationDelegate = authenticationDelegate
 self.requestManager = requestManager
 self.apiSpaceId = apiSpaceId
 self.tokenKey = authTokenKeychainItemNamePrefix + self.apiSpaceId
 self.detailsKey = sessionDetailsUserDefaultsPrefix + self.apiSpaceId
 
 self.loadSessionInfo()
 }
 
 internal func setDependencies(socketManager: SocketManager, client: ComapiClient){
 self.socketManager = socketManager
 self.client = client
 }
 
 internal func authenticate(_ onAuthenticationFinished: (()->())? = nil,_ onAuthenticationFailed: ((Error)->())? = nil) {
 self.client?.state = .sessionStarting
 self.onAuthenticationFinished = onAuthenticationFinished
 self.onAuthenticationFailed = onAuthenticationFailed
 self.socketManager?.closeSocket()
 self.client?.services.session.startAuthentication(challengeHandler: self)
 }
 
 private func loadSessionInfo() {
 if(!KeychainWrapper.standard.hasValue(forKey: self.tokenKey) || UserDefaults.standard.object(forKey: self.detailsKey) == nil){
 self.sessionAuth = nil
 return
 }
 
 let json = UserDefaults.standard.string(forKey: detailsKey)!.data(using: .utf8)!
 let session = try! Session.from(JSONDecoder.default().decode(Session.JSON.self, from: json))
 let token = KeychainWrapper.standard.string(forKey: self.tokenKey)!
 
 let sessionAuth = SessionAuth.init(token: token, sessionInfo: session)
 self.sessionAuth = sessionAuth
 self.requestManager.updateToken(with: token);
 }
 
 fileprivate func saveSessionInfo(){
 if(self.sessionAuth == nil){
 return
 }
 
 let details = self.sessionAuth!
 KeychainWrapper.standard.set(details.token, forKey: self.tokenKey, withAccessibility: KeychainItemAccessibility.afterFirstUnlockThisDeviceOnly)
 let data: Data = try! JSONEncoder.default().encode(details.sessionInfo.toJSON())
 let json = String.init(data: data, encoding: .utf8)
 UserDefaults.standard.set(json, forKey: self.detailsKey)
 }
 }
 
 extension SessionManager : AuthChallengeHandler {
 internal func handleAuthenticationChallenge(_ challenge: AuthenticationChallenge) {
 let client = self.client!
 self.authenticationDelegate?.client(client,
 didReceiveAuthenticationChallenge: challenge) { (payload) in
 do {
 try client.services.session.continueAuthentication(with: payload.unwrapped(),
 for: challenge.authenticationID,
 challengeHandler: self)
 }
 catch {
 self.authenticationFailed(with: error)
 }
 }
 }
 
 internal func authenticationFinished(with sessionAuth: SessionAuth) {
 log.info("Authorization finished with sessionAuth:", log(sessionAuth))
 self.sessionAuth = sessionAuth
 self.saveSessionInfo()
 self.requestManager.updateToken(with: sessionAuth.token)
 self.socketManager?.startSocket()
 
 let secondsTillTokenExpiry = sessionAuth.sessionInfo.expiresOn.timeIntervalSinceNow
 log.info("secondsTillTokenExpiry:", secondsTillTokenExpiry)
 
 DispatchQueue.main.asyncAfter(wallDeadline: .now() + secondsTillTokenExpiry) { [weak self] in
 if self?.sessionAuth?.sessionInfo.id == sessionAuth.sessionInfo.id {
 self?.authenticate()
 }
 }
 onAuthenticationFinished?()
 self.client?.state = .sessionActive
 }
 
 internal func authenticationFailed(with error: Error) {
 self.requestManager.tokenUpdateFailed()
 onAuthenticationFailed?(error)
 self.client?.state = .sessionOff
 }
 
 }

 */- (void)authenticateWithSuccess:(void (^ _Nullable)(void))success failure:(void (^ _Nullable)(NSError * _Nonnull))failure {
     <#code#>
 }

- (void)authenticationFailedWithError:(nonnull NSError *)error {
    <#code#>
}

- (void)authenticationFinishedWithSessionAuth:(nonnull CMPSessionAuth *)sessionAuth {
    <#code#>
}

- (void)handleAuthenticationChallenge:(nonnull CMPAuthenticationChallenge *)challenge {
    <#code#>
}


