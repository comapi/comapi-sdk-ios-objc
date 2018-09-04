//
//  CMPErrors.h
//  comapi-ios-sdk-objective-c
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
    CMPRequestTemplateErrorUnexpectedStatusCode
};

typedef NS_ENUM(NSUInteger, CMPAuthenticationError) {
    CMPAuthenticationErrorMissingToken,
};

typedef NS_ENUM(NSUInteger, CMPComapiError) {
    CMPComapiErrorAlreadyInitialised,
    CMPComapiErrorNotInitialised,
};

@interface CMPErrors : NSObject

+ (NSError *)requestTemplateErrorWithStatus:(CMPRequestTemplateError)status underlyingError:(NSError * _Nullable)error;
+ (NSError *)authenticationErrorWithStatus:(CMPAuthenticationError)status underlyingError:(NSError * _Nullable)error;
+ (NSError *)comapiErrorWithStatus:(CMPComapiError)status underlyingError:(NSError * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
