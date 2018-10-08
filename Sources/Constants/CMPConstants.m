//
//  CMPConstants.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPConstants.h"

NSString * const CMPRequestTemplateErrorDomain = @"com.comapi.foundation.request.template";

CMPRequestTemplateErrorStatusCode const CMPRequestTemplateErrorRequestCreationFailedStatusCode = 5551;
CMPRequestTemplateErrorStatusCode const CMPRequestTemplateErrorResponseParsingFailedStatusCode = 5552;
CMPRequestTemplateErrorStatusCode const CMPRequestTemplateErrorConnectionFailedStatusCode = 5553;
CMPRequestTemplateErrorStatusCode const CMPRequestTemplateErrorWrongCodeStatusCode = 5554;
CMPRequestTemplateErrorStatusCode const CMPRequestTemplateErrorNotFoundStatusCode = 5555;
CMPRequestTemplateErrorStatusCode const CMPRequestTemplateErrorUpdateConflictStatusCode = 5556;
CMPRequestTemplateErrorStatusCode const CMPRequestTemplateErrorAlreadyExistsStatusCode = 5557;

NSString * const CMPAuthenticationErrorDomain = @"com.comapi.foundation.authentication";

CMPAuthenticationErrorStatusCode const CMPAuthenticationErrorMissingTokenStatusCode = 5561;

CMPHTTPMethod const CMPHTTPMethodGET = @"GET";
CMPHTTPMethod const CMPHTTPMethodPOST = @"POST";
CMPHTTPMethod const CMPHTTPMethodPUT = @"PUT";
CMPHTTPMethod const CMPHTTPMethodPATCH = @"PATCH";
CMPHTTPMethod const CMPHTTPMethodDELETE = @"DELETE";
CMPHTTPMethod const CMPHTTPMethodHEAD = @"HEAD";

CMPHTTPHeaderType const CMPHTTPHeaderContentType = @"Content-Type";
CMPHTTPHeaderType const CMPHTTPHeaderAuthorization = @"Authorization";
CMPHTTPHeaderType const CMPHTTPHeaderIfMatch = @"If-Match";

CMPSDKInfo const CMPSDKInfoPlatform = @"iOS";
CMPSDKInfo const CMPSDKInfoVersion = @"1.0.0";
CMPSDKInfo const CMPSDKInfoType = @"native";

CMPQueueName const CMPQueueNameConsole = @"com.comapi.foundation.console";
CMPQueueName const CMPQueueNameFileDestination = @"com.comapi.foundation.log.fileDestination";

NSString * const CMPDefaultTerminator = @"\n";
NSString * const CMPDefaultSeparator = @"\n";

NSString * const CMPLogFileName = @"comapi.foundation.log";
