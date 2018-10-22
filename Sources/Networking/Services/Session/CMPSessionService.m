//
// The MIT License (MIT)
// Copyright (c) 2017 Comapi (trading name of Dynmark International Limited)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "CMPSessionService.h"
#import "CMPStartNewSessionTemplate.h"
#import "CMPAuthorizeSessionTemplate.h"
#import "CMPDeleteSessionTemplate.h"

@implementation CMPSessionService

- (void)startSessionWithCompletion:(void (^)(void))completion failure:(void (^)(NSError * _Nullable))failure {
    [self.sessionAuthProvider authenticateWithSuccess:completion failure:failure];
}

- (void)endSessionWithCompletion:(void (^)(BOOL, NSError * _Nullable))completion {
    CMPDeleteSessionTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPDeleteSessionTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID token:token sessionID:self.sessionAuthProvider.sessionAuth.session.id];
    };

    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPRequestTemplateResult * result) {
        if (result.error) {
            completion(NO, result.error);
        } else {
            completion(YES, nil);
        }
    }];
}

- (void)startAuthenticationWithChallengeHandler:(id<CMPAuthChallengeHandler>)challengeHandler {
    CMPStartNewSessionTemplate *template = [[CMPStartNewSessionTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID];
    [template performWithRequestPerformer:self.requestManager.requestPerformer result:^(CMPRequestTemplateResult *result) {
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
    
    [template performWithRequestPerformer:self.requestManager.requestPerformer result:^(CMPRequestTemplateResult *result) {
        CMPSessionAuth *sessionAuth = (CMPSessionAuth *)result.object;
        if (!sessionAuth) {
            [challengeHandler authenticationFailedWithError:result.error];
        } else {
            [challengeHandler authenticationFinishedWithSessionAuth:sessionAuth];
        }
    }];
}

@end
