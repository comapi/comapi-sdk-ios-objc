//
//  CMPSessionService.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 23/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSessionService.h"
#import "CMPStartNewSessionTemplate.h"
#import "CMPAuthorizeSessionTemplate.h"
#import "CMPDeleteSessionTemplate.h"

@implementation CMPSessionService

- (void)startSessionWithCompletion:(void (^)(void))completion failure:(void (^)(NSError * _Nullable))failure {
    [self.sessionAuthProvider authenticateWithSuccess:completion failure:failure];
}

- (void)endSessionWithCompletion:(void (^)(CMPRequestTemplateResult *))completion {
    CMPDeleteSessionTemplate *template = [[CMPDeleteSessionTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID];
    [self.requestManager performUsingTemplate:template completion:^(CMPRequestTemplateResult * result) {
        completion(result);
    }];
}

- (void)startAuthenticationWithChallengeHandler:(id<CMPAuthChallengeHandler>)challengeHandler {
    CMPStartNewSessionTemplate *template = [[CMPStartNewSessionTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID];
    [self.requestManager performUsingTemplate:template completion:^(CMPRequestTemplateResult * result) {
        CMPAuthenticationChallenge* challenge = (CMPAuthenticationChallenge *)result.object;
        if (!challenge) {
            [challengeHandler authenticationFailedWithError:result.error];
        } else {
            [challengeHandler handleAuthenticationChallenge:challenge];
        }
    }];
}

- (void)continueAuthenticationWithToken:(NSString *)token forAuthenticationID:(NSString *)authenticationID challengeHandler:(id<CMPAuthChallengeHandler>)challengeHandler {
    CMPAuthorizeSessionBody *body = [[CMPAuthorizeSessionBody alloc] initWithAuthenticationID:authenticationID authenticationToken:token];
    CMPAuthorizeSessionTemplate *template = [[CMPAuthorizeSessionTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID body:body];
    [self.requestManager performUsingTemplate:template completion:^(CMPRequestTemplateResult * result) {
        CMPSessionAuth *sessionAuth = (CMPSessionAuth *)result.object;
        if (!sessionAuth) {
            [challengeHandler authenticationFailedWithError:result.error];
        } else {
            [challengeHandler authenticationFinishedWithSessionAuth:sessionAuth];
        }
    }];
}

@end
