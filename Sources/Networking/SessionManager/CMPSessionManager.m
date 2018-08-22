//
//  SessionManager.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 14/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSessionManager.h"
#import "CMPSession.h"

@interface CMPSessionManager ()
    
@property (nonatomic, nullable) CMPSessionAuth* sessionAuth;
    
@end

@implementation CMPSessionManager

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

 */
