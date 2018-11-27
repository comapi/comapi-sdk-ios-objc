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
@protocol CMPSessionServiceable <NSObject>

/**
 @brief Starts a Comapi session allowing for further Comapi service calls.
 @param completion Block called on success.
 @param failure Block called on failure, returns an NSError if one occurs.
 */
- (void)startSessionWithCompletion:(void(^)(void))completion failure:(void(^)(NSError * _Nullable))failure NS_SWIFT_NAME(startSession(completion:failure:));

/**
 @brief Ends a Comapi session.
 @param completion Block with a result value, the @b object returned is of type @a NSNumber* (mapping to BOOL determining successful session finish) or nil if an error occurred.
 */
- (void)endSessionWithCompletion:(void (^)(CMPResult<NSNumber *> *))completion
    NS_SWIFT_NAME(endSession(completion:));

/**
 @brief Part of session starting procedure, asks the passed challangeHandler to provide a valid JWT authentication token.
 @param challengeHandler A CMPAuthChallengeHandler conforming object providing a JWT token.
 @warning Do not call this method or implement your own @a CMPAuthChallengeHandler, sessions are handled by @a CMPSessionManager.
 */
- (void)startAuthenticationWithChallengeHandler:(id<CMPAuthChallengeHandler>)challengeHandler NS_SWIFT_NAME(startAuthentication(challengeHandler:));

/**
 @brief Part of session starting procedure, the obtained token is sent back to Comapi servers for validation.
 @param token The obtained authentication token.
 @param authenticationID Authentication token Id.
 @param challengeHandler A CMPAuthChallengeHandler conforming object providing a JWT token.
 @warning Do not call this method, sessions are handled by @a CMPSessionManager.
 */
- (void)continueAuthenticationWithToken:(NSString *)token forAuthenticationID:(NSString *)authenticationID challengeHandler:(id<CMPAuthChallengeHandler>)challengeHandler
    NS_SWIFT_NAME(continueAuthentication(token:authenticationID:challengeHandler:));

@end

/**
 @brief Session related Comapi services.
 */
NS_SWIFT_NAME(SessionService)
@interface CMPSessionService : CMPBaseService <CMPSessionServiceable>

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
