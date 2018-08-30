//
//  CMPAuthChallengeHandler.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 29/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAuthenticationChallenge.h"
#import "CMPSessionAuth.h"

@protocol CMPAuthChallengeHandler

- (void)handleAuthenticationChallenge:(CMPAuthenticationChallenge *)challenge;
- (void)authenticationFailedWithError:(NSError *)error;
- (void)authenticationFinishedWithSessionAuth:(CMPSessionAuth *)sessionAuth;

@end
