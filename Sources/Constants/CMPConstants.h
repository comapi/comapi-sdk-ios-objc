//
//  CMPConstants.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CMPRequestTemplateErrorDomain NS_SWIFT_NAME(RequestTemplateErrorDomain);

typedef NSUInteger CMPRequestTemplateErrorStatusCode NS_TYPED_ENUM NS_SWIFT_NAME(RequestTemplateErrorStatusCode);

extern CMPRequestTemplateErrorStatusCode const CMPRequestTemplateErrorRequestCreationFailedStatusCode NS_SWIFT_NAME(creationFailed);
extern CMPRequestTemplateErrorStatusCode const CMPRequestTemplateErrorResponseParsingFailedStatusCode NS_SWIFT_NAME(parsingFailed);
extern CMPRequestTemplateErrorStatusCode const CMPRequestTemplateErrorConnectionFailedStatusCode NS_SWIFT_NAME(connectionFailed);
extern CMPRequestTemplateErrorStatusCode const CMPRequestTemplateErrorWrongCodeStatusCode NS_SWIFT_NAME(wrongStatusCode);
extern CMPRequestTemplateErrorStatusCode const CMPRequestTemplateErrorNotFoundStatusCode NS_SWIFT_NAME(notFound);
extern CMPRequestTemplateErrorStatusCode const CMPRequestTemplateErrorUpdateConflictStatusCode NS_SWIFT_NAME(updateConflict);

extern NSString * const CMPAuthenticationErrorDomain NS_SWIFT_NAME(AuthenticationErrorDomain);

typedef NSUInteger CMPAuthenticationErrorStatusCode NS_TYPED_ENUM NS_SWIFT_NAME(AuthenticationErrorStatusCode);

extern CMPAuthenticationErrorStatusCode const CMPAuthenticationErrorMissingTokenStatusCode NS_SWIFT_NAME(missingToken);

typedef NSString * CMPHTTPMethod NS_TYPED_ENUM NS_SWIFT_NAME(HTTPMethod);

extern CMPHTTPMethod const CMPHTTPMethodGET NS_SWIFT_NAME(get);
extern CMPHTTPMethod const CMPHTTPMethodPOST NS_SWIFT_NAME(post);
extern CMPHTTPMethod const CMPHTTPMethodPUT NS_SWIFT_NAME(put);
extern CMPHTTPMethod const CMPHTTPMethodPATCH NS_SWIFT_NAME(patch);
extern CMPHTTPMethod const CMPHTTPMethodDELETE NS_SWIFT_NAME(delete);
extern CMPHTTPMethod const CMPHTTPMethodHEAD NS_SWIFT_NAME(head);

typedef NSString * CMPHTTPHeaderType NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(HTTPHeaderType);

extern CMPHTTPHeaderType const CMPHTTPHeaderContentType NS_SWIFT_NAME(contentType);
extern CMPHTTPHeaderType const CMPHTTPHeaderAuthorization NS_SWIFT_NAME(authorization);
extern CMPHTTPHeaderType const CMPHTTPHeaderIfMatch NS_SWIFT_NAME(ifMatch);

typedef NSString * CMPSDKInfo NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(SDKInfo);

extern CMPSDKInfo const CMPSDKInfoPlatform NS_SWIFT_NAME(platform);
extern CMPSDKInfo const CMPSDKInfoVersion NS_SWIFT_NAME(version);
extern CMPSDKInfo const CMPSDKInfoType NS_SWIFT_NAME(type);

typedef NSString * CMPQueueName NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(QueueName);

extern CMPQueueName const CMPQueueNameConsole NS_SWIFT_NAME(console);
extern CMPQueueName const CMPQueueNameFileDestination NS_SWIFT_NAME(file);

extern NSString * const CMPLogFileName NS_SWIFT_NAME(LogFileName);

extern NSString * const CMPDefaultTerminator NS_SWIFT_NAME(DefaultTerminator);
extern NSString * const CMPDefaultSeparator NS_SWIFT_NAME(DefaultSeparator);
