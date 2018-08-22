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
    CMPRequestTemplateErrorUnauthorized
};

@interface CMPErrors : NSObject

+ (NSError *)errorWithStatus:(CMPRequestTemplateError)status underlyingError:(NSError * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
