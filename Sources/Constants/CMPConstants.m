//
//  CMPConstants.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPConstants.h"

NSString * const CMPRequestTemplateErrorDomain = @"com.comapi.foundation.request.template";

NSUInteger const CMPRequestTemplateErrorRequestCreationFailedStatusCode = 5551;
NSUInteger const CMPRequestTemplateErrorResponseParsingFailedStatusCode = 5552;
NSUInteger const CMPRequestTemplateErrorConnectionFailedStatusCode = 5553;
NSUInteger const CMPRequestTemplateErrorWrongCodeStatusCode = 5554;

NSString * const CMPAuthenticationErrorDomain = @"com.comapi.foundation.authentication";

NSUInteger const CMPAuthenticationErrorMissingTokenStatusCode = 5561;

NSString * const CMPComapiErrorDomain = @"com.comapi.foundation.comapi";

NSUInteger const CMPComapiErrorAlreadyInitialisedStatusCode = 5571;
NSUInteger const CMPComapiErrorNotInitialisedStatusCode = 5572;

NSString * const CMPHTTPMethodGET = @"GET";
NSString * const CMPHTTPMethodPOST = @"POST";
NSString * const CMPHTTPMethodPUT = @"PUT";
NSString * const CMPHTTPMethodPATCH = @"PATCH";
NSString * const CMPHTTPMethodDELETE = @"DELETE";
NSString * const CMPHTTPMethodHEAD = @"HEAD";

NSString * const CMPHTTPHeaderContentType = @"Content-Type";
NSString * const CMPHTTPHeaderAuthorization = @"Authorization";
NSString * const CMPHTTPHeaderIfMatch = @"If-Match";

NSString * const CMPHTTPHeaderContentTypeJSON = @"application/json";
NSString * const CMPHTTPHeaderContentTypeURL = @"application/x-www-form-urlencoded";

NSString * const CMPPlatformInfo = @"iOS";

NSString * const CMPSDKVersion = @"1.0.0";
NSString * const CMPSDKType = @"native";

NSString * const CMPQueueNameLog = @"com.comapi.foundation.log";
NSString * const CMPQueueNameFileDestination = @"com.comapi.foundation.log.fileDestination";

NSString * const CMPDefaultTerminator = @"\n";
NSString * const CMPDefaultSeparator = @"\n";

NSString * const CMPLogFileName = @"comapi.foundation.log";
