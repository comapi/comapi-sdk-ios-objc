//
//  CMPSessionService.m
//  CMPComapiFoundation
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

- (void)endSessionWithCompletion:(void (^)(CMPResult<NSNumber *> *))completion {
    CMPDeleteSessionTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPDeleteSessionTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID token:token sessionID:self.sessionAuthProvider.sessionAuth.session.id];
    };

    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<NSNumber *> * result) {
        completion(result);
    }];
}

- (void)startAuthenticationWithChallengeHandler:(id<CMPAuthChallengeHandler>)challengeHandler {
    CMPStartNewSessionTemplate *template = [[CMPStartNewSessionTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID];
    [template performWithRequestPerformer:self.requestManager.requestPerformer result:^(CMPResult<CMPAuthenticationChallenge *> * result) {
        if (result.error) {
            [challengeHandler authenticationFailedWithError:result.error];
        } else {
            [challengeHandler handleAuthenticationChallenge:result.object];
        }
    }];
}

- (void)continueAuthenticationWithToken:(NSString *)token forAuthenticationID:(NSString *)authenticationID challengeHandler:(id<CMPAuthChallengeHandler>)challengeHandler {
    CMPAuthorizeSessionBody *body = [[CMPAuthorizeSessionBody alloc] initWithAuthenticationID:authenticationID authenticationToken:token];
    CMPAuthorizeSessionTemplate *template = [[CMPAuthorizeSessionTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID body:body];
    
    [template performWithRequestPerformer:self.requestManager.requestPerformer result:^(CMPResult<CMPSessionAuth *> *result) {
        if (result.error) {
            [challengeHandler authenticationFailedWithError:result.error];
        } else {
            [challengeHandler authenticationFinishedWithSessionAuth:result.object];
        }
    }];
}

@end
