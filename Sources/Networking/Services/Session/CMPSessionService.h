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

@protocol CMPSessionServiceable

- (void)startSessionWithCompletion:(void(^)(void))completion failure:(void(^)(NSError * _Nullable))failure;
- (void)endSessionWithCompletion:(void (^)(BOOL, NSError * _Nullable))completion;
- (void)startAuthenticationWithChallengeHandler:(id<CMPAuthChallengeHandler>)challengeHandler;
- (void)continueAuthenticationWithToken:(NSString *)token forAuthenticationID:(NSString *)authenticationID challengeHandler:(id<CMPAuthChallengeHandler>)challengeHandler;

@end

@interface CMPSessionService : CMPBaseService <CMPSessionServiceable>

@end

NS_ASSUME_NONNULL_END
