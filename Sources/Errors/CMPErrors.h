//
//  CMPErrors.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 @typedef CMPRequestTemplateError
 @brief Defines error types that can be returned by Comapi services.
 */
typedef NS_ENUM(NSUInteger, CMPRequestTemplateError) {
    /// Request is malformed and couldn't be created.
    CMPRequestTemplateErrorRequestCreationFailed,
    /// Response JSON failed to be parsed.
    CMPRequestTemplateErrorResponseParsingFailed,
    /// Could not establish a connection between client and server.
    CMPRequestTemplateErrorConnectionFailed,
    /// Wildcard error for various unexpected errors.
    CMPRequestTemplateErrorUnexpectedStatusCode,
    /// Object with specified criteria does not exist.
    CMPRequestTemplateErrorNotFound,
    /// Object could not be updated due to conflicts.
    CMPRequestTemplateErrorUpdateConflict,
    /// Object could not be created because it already exists.
    CMPRequestTemplateErrorAlreadyExists
} NS_SWIFT_NAME(RequestTemplateError);

/**
 @typedef CMPAuthenticationError
 @brief Defines errors related to authenticating.
 */
typedef NS_ENUM(NSUInteger, CMPAuthenticationError) {
    /// Could not perform request due to missing authentication token.
    CMPAuthenticationErrorMissingToken,
} NS_SWIFT_NAME(AuthenticationError);

NS_SWIFT_NAME(Errors)
@interface CMPErrors : NSObject

+ (NSError *)requestTemplateErrorWithStatus:(CMPRequestTemplateError)status underlyingError:(NSError * _Nullable)error;
+ (NSError *)authenticationErrorWithStatus:(CMPAuthenticationError)status underlyingError:(NSError * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
