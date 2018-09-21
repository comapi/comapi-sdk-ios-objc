//
//  CMPConstants.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CMPRequestTemplateErrorDomain;

extern NSUInteger const CMPRequestTemplateErrorRequestCreationFailedStatusCode;
extern NSUInteger const CMPRequestTemplateErrorResponseParsingFailedStatusCode;
extern NSUInteger const CMPRequestTemplateErrorConnectionFailedStatusCode;
extern NSUInteger const CMPRequestTemplateErrorWrongCodeStatusCode;
extern NSUInteger const CMPRequestTemplateErrorNotFoundStatusCode;
extern NSUInteger const CMPRequestTemplateErrorUpdateConflictStatusCode;

extern NSString * const CMPAuthenticationErrorDomain;

extern NSUInteger const CMPAuthenticationErrorMissingTokenStatusCode;

extern NSString * const CMPComapiErrorDomain;

extern NSUInteger const CMPComapiErrorAlreadyInitialisedStatusCode;
extern NSUInteger const CMPComapiErrorNotInitialisedStatusCode;

extern NSString * const CMPHTTPMethodGET;
extern NSString * const CMPHTTPMethodPOST;
extern NSString * const CMPHTTPMethodPUT;
extern NSString * const CMPHTTPMethodPATCH;
extern NSString * const CMPHTTPMethodDELETE;
extern NSString * const CMPHTTPMethodHEAD;

extern NSString * const CMPHTTPHeaderContentType;
extern NSString * const CMPHTTPHeaderAuthorization;
extern NSString * const CMPHTTPHeaderIfMatch;

extern NSString * const CMPHTTPHeaderContentTypeJSON;
extern NSString * const CMPHTTPHeaderContentTypeURL;

extern NSString * const CMPPlatformInfo;

extern NSString * const CMPSDKVersion;
extern NSString * const CMPSDKType;

extern NSString * const CMPQueueNameLog;
extern NSString * const CMPQueueNameFileDestination;

extern NSString * const CMPLogFileName;

extern NSString * const CMPDefaultTerminator;
extern NSString * const CMPDefaultSeparator;
