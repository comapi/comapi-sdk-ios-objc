//
//  CMPConstants.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPConstants.h"

NSString * const CMPRequestTemplateErrorDomain = @"com.comapi.comapi-ios-sdk-objective-c.request.template";

NSUInteger const CMPRequestTemplateErrorRequestCreationFailedStatusCode = 5551;
NSUInteger const CMPRequestTemplateErrorResponseParsingFailedStatusCode = 5552;
NSUInteger const CMPRequestTemplateErrorConnectionFailedStatusCode = 5553;
NSUInteger const CMPRequestTemplateErrorUnauthorizedStatusCode = 5554;

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
