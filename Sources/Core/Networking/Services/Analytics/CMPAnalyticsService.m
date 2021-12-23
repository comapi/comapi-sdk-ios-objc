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

#import "CMPAnalyticsService.h"

#import "CMPSession.h"
#import "CMPAPIConfiguration.h"
#import "CMPStartNewSessionTemplate.h"
#import "CMPAuthorizeSessionTemplate.h"
#import "CMPDeleteSessionTemplate.h"
#import "CMPRequestManager.h"
#import "CMPAuthenticationChallenge.h"
#import "CMPAuthChallengeHandler.h"
#import "CMPSessionAuth.h"
#import "CMPSessionAuthProvider.h"
#import "CMPAuthorizeSessionBody.h"

@implementation CMPAnalyticsService

/**
 @brief Sends click data, internal only
 @param trackingUrl Url to use
 @param completion Block with a result value
 */
- (void)trackNotificationClick:(NSString *)trackingUrl completion:(void(^)(CMPResult<id> *))completion NS_SWIFT_NAME(sendClickData(trackingUrl:completion:)) {
    [self.requestManager performClickTrackingUsingUrl:trackingUrl completion:completion];
}

@end
