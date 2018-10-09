//
//  SessionManager.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 14/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSessionAuth.h"
#import "CMPComapiClient.h"
#import "CMPSessionAuthProvider.h"
#import "CMPAuthChallengeHandler.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SessionManager)
@interface CMPSessionManager : NSObject <CMPSessionAuthProvider, CMPAuthChallengeHandler>

@property (nonatomic, strong, nullable) CMPSessionAuth *sessionAuth;

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate requestManager:(CMPRequestManager *)requestManager;
- (BOOL)isSessionValid;
- (void)bindClient:(CMPComapiClient *)client;

@end

NS_ASSUME_NONNULL_END
