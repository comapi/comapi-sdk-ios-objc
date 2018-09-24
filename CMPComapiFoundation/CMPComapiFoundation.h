//
//  CMPComapiFoundation.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 14/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
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
#import <CMPComapiFoundation/CMPStreamRequestTemplate.h>
#import <CMPComapiFoundation/CMPAuthorizeSessionTemplate.h>
#import <CMPComapiFoundation/CMPDeleteSessionTemplate.h>
#import <CMPComapiFoundation/CMPStartNewSessionTemplate.h>
#import <CMPComapiFoundation/CMPAuthenticationChallenge.h>
#import <CMPComapiFoundation/CMPAuthorizeSessionBody.h>
#import <CMPComapiFoundation/CMPSession.h>
#import <CMPComapiFoundation/CMPSessionAuth.h>
#import <CMPComapiFoundation/CMPURLResult.h>
#import <CMPComapiFoundation/CMPKeychain.h>
#import <CMPComapiFoundation/CMPUtilities.h>
#import <CMPComapiFoundation/NSData+CMPUtility.h>
#import <CMPComapiFoundation/NSDateFormatter+CMPUtility.h>
#import <CMPComapiFoundation/NSString+CMPUtility.h>
#import <CMPComapiFoundation/NSURLResponse+CMPUtility.h>


