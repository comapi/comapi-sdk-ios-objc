//
//  CMPErrors.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CMPRequestTemplateError) {
    CMPRequestTemplateErrorRequestCreationFailed,
    CMPRequestTemplateErrorResponseParsingFailed,
    CMPRequestTemplateErrorConnectionFailed,
    CMPRequestTemplateErrorUnexpectedStatusCode,
    CMPRequestTemplateErrorNotFound,
    CMPRequestTemplateErrorUpdateConflict
} NS_SWIFT_NAME(RequestTemplateError);

typedef NS_ENUM(NSUInteger, CMPAuthenticationError) {
    CMPAuthenticationErrorMissingToken,
} NS_SWIFT_NAME(AuthenticationError);

NS_SWIFT_NAME(Errors)
@interface CMPErrors : NSObject

+ (NSError *)requestTemplateErrorWithStatus:(CMPRequestTemplateError)status underlyingError:(NSError * _Nullable)error;
+ (NSError *)authenticationErrorWithStatus:(CMPAuthenticationError)status underlyingError:(NSError * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
