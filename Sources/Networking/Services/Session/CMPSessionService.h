//
//  CMPSessionService.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 23/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPBaseService.h"
#import "CMPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPSessionService : CMPBaseService


- (void)startSessionWithCompletion:(void(^)(void))completion failure:(void(^)(NSError * _Nullable))failure;
- (void)endSessionWithCompletion:(void(^)(void))completion failure:(void(^)(void))failure;
- (void)startAuthenticationWithChallengeHandler:(id<CMPAuthChallengeHandler>)challengeHandler;
- (void)continueAuthenticationWithToken:(NSString *)token forAuthenticationID:(NSString *)authenticationID challengeHandler:(id<CMPAuthChallengeHandler>)challengeHandler;

@end

NS_ASSUME_NONNULL_END
