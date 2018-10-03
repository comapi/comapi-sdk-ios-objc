//
//  CMPAuthChallengeHandler.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 29/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAuthenticationChallenge.h"
#import "CMPSessionAuth.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AuthChallengeHandler)
@protocol CMPAuthChallengeHandler

- (void)handleAuthenticationChallenge:(CMPAuthenticationChallenge *)challenge;
- (void)authenticationFailedWithError:(NSError *)error;
- (void)authenticationFinishedWithSessionAuth:(CMPSessionAuth *)sessionAuth;

@end

NS_ASSUME_NONNULL_END
