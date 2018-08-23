//
//  CMPConstants.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CMPRequestTemplateErrorDomain;

extern NSUInteger const CMPRequestTemplateErrorRequestCreationFailedStatusCode;
extern NSUInteger const CMPRequestTemplateErrorResponseParsingFailedStatusCode;
extern NSUInteger const CMPRequestTemplateErrorConnectionFailedStatusCode;
extern NSUInteger const CMPRequestTemplateErrorUnauthorizedStatusCode;

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
