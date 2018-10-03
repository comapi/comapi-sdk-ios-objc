//
//  CMPSessionService.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 23/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseService.h"
#import "CMPAuthChallengeHandler.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SessionServiceable)
@protocol CMPSessionServiceable

- (void)startSessionWithCompletion:(void(^)(void))completion failure:(void(^)(NSError * _Nullable))failure NS_SWIFT_NAME(startSession(completion:failure:));
- (void)endSessionWithCompletion:(void (^)(BOOL, NSError * _Nullable))completion
    NS_SWIFT_NAME(endSession(completion:));
- (void)startAuthenticationWithChallengeHandler:(id<CMPAuthChallengeHandler>)challengeHandler NS_SWIFT_NAME(startAuthentication(challengeHandler:));
- (void)continueAuthenticationWithToken:(NSString *)token forAuthenticationID:(NSString *)authenticationID challengeHandler:(id<CMPAuthChallengeHandler>)challengeHandler
    NS_SWIFT_NAME(continueAuthentication(token:authenticationID:challengeHandler:));

@end

NS_SWIFT_NAME(SessionService)
@interface CMPSessionService : CMPBaseService <CMPSessionServiceable>

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
