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

#import <Foundation/Foundation.h>

//! Project version number for CMPComapiFoundation.
FOUNDATION_EXPORT double CMPComapiFoundationVersionNumber;

//! Project version string for CMPComapiFoundation.
FOUNDATION_EXPORT const unsigned char CMPComapiFoundationVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CMPComapiFoundation/PublicHeader.h>

#import <CMPComapiFoundation/CMPComapiClient.h>
#import <CMPComapiFoundation/CMPComapi.h>
#import <CMPComapiFoundation/CMPAPIConfiguration.h>
#import <CMPComapiFoundation/CMPComapiConfig.h>
#import <CMPComapiFoundation/CMPConstants.h>
#import <CMPComapiFoundation/CMPErrors.h>
#import <CMPComapiFoundation/CMPLog.h>
#import <CMPComapiFoundation/CMPLogger.h>
#import <CMPComapiFoundation/CMPLogLevel.h>
#import <CMPComapiFoundation/CMPLogConfig.h>
#import <CMPComapiFoundation/CMPFileDestination.h>
#import <CMPComapiFoundation/CMPLoggingDestination.h>
#import <CMPComapiFoundation/CMPXcodeConsoleDestination.h>
#import <CMPComapiFoundation/CMPAuthenticationDelegate.h>
#import <CMPComapiFoundation/CMPHTTPHeader.h>
#import <CMPComapiFoundation/CMPJSONDecoding.h>
#import <CMPComapiFoundation/CMPJSONEncoding.h>
#import <CMPComapiFoundation/CMPRequestManager.h>
#import <CMPComapiFoundation/CMPRequestPerformer.h>
#import <CMPComapiFoundation/CMPRequestPerforming.h>
#import <CMPComapiFoundation/CMPBaseService.h>
#import <CMPComapiFoundation/CMPServices.h>
#import <CMPComapiFoundation/CMPProfileService.h>
#import <CMPComapiFoundation/CMPSessionService.h>
#import <CMPComapiFoundation/CMPAuthChallengeHandler.h>
#import <CMPComapiFoundation/CMPSessionAuthProvider.h>
#import <CMPComapiFoundation/CMPSessionManager.h>
#import <CMPComapiFoundation/CMPGetProfileTemplate.h>
#import <CMPComapiFoundation/CMPPatchProfileTemplate.h>
#import <CMPComapiFoundation/CMPQueryProfilesTemplate.h>
#import <CMPComapiFoundation/CMPUpdateProfileTemplate.h>
#import <CMPComapiFoundation/CMPProfile.h>
#import <CMPComapiFoundation/CMPQueryBuilder.h>
#import <CMPComapiFoundation/CMPSetAPNSDetailsTemplate.h>
#import <CMPComapiFoundation/CMPAPNSDetails.h>
#import <CMPComapiFoundation/CMPAPNSDetailsBody.h>
#import <CMPComapiFoundation/CMPHTTPRequestTemplate.h>
#import <CMPComapiFoundation/CMPRequestTemplate.h>
#import <CMPComapiFoundation/CMPRequestTemplateResult.h>
#import <CMPComapiFoundation/CMPAuthorizeSessionTemplate.h>
#import <CMPComapiFoundation/CMPDeleteSessionTemplate.h>
#import <CMPComapiFoundation/CMPStartNewSessionTemplate.h>
#import <CMPComapiFoundation/CMPAuthenticationChallenge.h>
#import <CMPComapiFoundation/CMPAuthorizeSessionBody.h>
#import <CMPComapiFoundation/CMPSession.h>
#import <CMPComapiFoundation/CMPSessionAuth.h>
#import <CMPComapiFoundation/CMPURLResult.h>
#import <CMPComapiFoundation/CMPKeychain.h>
#import <CMPComapiFoundation/NSData+CMPUtility.h>
#import <CMPComapiFoundation/NSDateFormatter+CMPUtility.h>
#import <CMPComapiFoundation/NSString+CMPUtility.h>
#import <CMPComapiFoundation/NSURLResponse+CMPUtility.h>


