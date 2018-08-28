//
//  CMPErrors.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPErrors.h"
#import "CMPConstants.h"

@implementation CMPErrors

+ (NSError *)requestTemplateErrorWithStatus:(CMPRequestTemplateError)status underlyingError:(NSError *)error {
    switch (status) {
        case CMPRequestTemplateErrorRequestCreationFailed:
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorRequestCreationFailedStatusCode userInfo:@{NSUnderlyingErrorKey : error}];
            break;
        case CMPRequestTemplateErrorResponseParsingFailed:
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorResponseParsingFailedStatusCode userInfo:@{NSUnderlyingErrorKey : error}];
            break;
        case CMPRequestTemplateErrorConnectionFailed:
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorConnectionFailedStatusCode userInfo:@{NSUnderlyingErrorKey : error}];
            break;
        case CMPRequestTemplateErrorUnauthorized:
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorUnauthorizedStatusCode userInfo:@{NSUnderlyingErrorKey : error}];
            break;
    }
}

+ (NSError *)authenticationErrorWithStatus:(CMPAuthenticationError)status underlyingError:(NSError *)error {
    switch (status) {
        case CMPAuthenticationErrorMissingToken:
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorConnectionFailedStatusCode userInfo:@{NSUnderlyingErrorKey : error}];
            break;
        
            break;
    }
}

@end
