//
//  CMPResult.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 29/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Result)
@interface CMPResult<__covariant T> : NSObject

@property (nonatomic, nullable) T object;
@property (nonatomic, nullable) NSError *error;
@property (nonatomic, nullable) NSString *eTag;
@property (nonatomic) NSInteger code;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithObject:(nullable T)object error:(nullable NSError *)error eTag:(nullable NSString *)eTag code:(NSInteger)code;

@end

NS_ASSUME_NONNULL_END
