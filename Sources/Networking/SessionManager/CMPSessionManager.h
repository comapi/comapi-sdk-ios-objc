//
//  SessionManager.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 14/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPSessionAuth.h"
#import "CMPRequestManager.h"


NS_ASSUME_NONNULL_BEGIN

@protocol CMPSessionAuthProvider

- (void)authenticateWithSuccess:(void(^ _Nullable)(void))success failure:(void(^ _Nullable)(NSError *))failure;

@end

@protocol CMPAuthChallengeHandler

- (void)handleAuthenticationChallenge:(CMPAuthenticationChallenge *)challenge;
- (void)authenticationFailedWithError:(NSError *)error;
- (void)authenticationFinishedWithSessionAuth:(CMPSessionAuth *)sessionAuth;

@end

@interface CMPSessionManager : NSObject <CMPSessionAuthProvider, CMPAuthChallengeHandler>

@property (nonatomic, strong, nullable) CMPSessionAuth *sessionAuth;

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate requestManager:(CMPRequestManager *)requestManager;
- (BOOL)isSessionValid;
- (void)bindClient:(CMPComapiClient *)client;

@end

NS_ASSUME_NONNULL_END
