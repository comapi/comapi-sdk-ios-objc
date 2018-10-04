//
//  CMPRequestTemplateResult.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 29/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(RequestTemplateResult)
@interface CMPRequestTemplateResult : NSObject

@property (nonatomic, nullable) id object;
@property (nonatomic, nullable) NSError *error;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithObject:(nullable id)object error:(nullable NSError *)error;

@end

NS_ASSUME_NONNULL_END
