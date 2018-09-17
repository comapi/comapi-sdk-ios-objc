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
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorRequestCreationFailedStatusCode userInfo:error != nil ? @{NSUnderlyingErrorKey : error} : @{}];
        case CMPRequestTemplateErrorResponseParsingFailed:
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorResponseParsingFailedStatusCode userInfo:error != nil ? @{NSUnderlyingErrorKey : error} : @{}];
        case CMPRequestTemplateErrorConnectionFailed:
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorConnectionFailedStatusCode userInfo:error != nil ? @{NSUnderlyingErrorKey : error} : @{}];
        case CMPRequestTemplateErrorUnexpectedStatusCode:
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorWrongCodeStatusCode userInfo:error != nil ? @{NSUnderlyingErrorKey : error} : @{}];
        case CMPRequestTemplateErrorNotFound:
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorNotFoundStatusCode userInfo:error != nil ? @{NSUnderlyingErrorKey : error} : @{}];
        case CMPRequestTemplateErrorUpdateConflict:
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorUpdateConflict userInfo:error != nil ? @{NSUnderlyingErrorKey : error} : @{}];
    }
}

+ (NSError *)authenticationErrorWithStatus:(CMPAuthenticationError)status underlyingError:(NSError *)error {
    switch (status) {
        case CMPAuthenticationErrorMissingToken:
            return [[NSError alloc] initWithDomain:CMPAuthenticationErrorDomain code:CMPAuthenticationErrorMissingTokenStatusCode userInfo:@{NSUnderlyingErrorKey : error}];
    }
}

+ (NSError *)comapiErrorWithStatus:(CMPComapiError)status underlyingError:(NSError *)error {
    switch (status) {
        case CMPComapiErrorNotInitialised:
            return [[NSError alloc] initWithDomain:CMPComapiErrorDomain code:CMPComapiErrorNotInitialisedStatusCode userInfo:@{NSUnderlyingErrorKey : error}];
        case CMPComapiErrorAlreadyInitialised:
            return [[NSError alloc] initWithDomain:CMPComapiErrorDomain code:CMPComapiErrorAlreadyInitialisedStatusCode userInfo:@{NSUnderlyingErrorKey : error}];
        default:
            break;
    }
}

@end
