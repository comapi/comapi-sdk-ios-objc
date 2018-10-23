//
//  CMPMessagePart.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONEncoding.h"
#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPMessagePart : NSObject <CMPJSONEncoding, CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSString *type;
@property (nonatomic, strong, nullable) NSString *data;
@property (nonatomic, strong, nullable) NSNumber *size;
@property (nonatomic, strong, nullable) NSURL *url;

- (instancetype)initWithName:(nullable NSString *)name type:(nullable NSString *)type url:(nullable NSURL *)url data:(nullable NSString *)data size:(nullable NSNumber *)size;

@end

NS_ASSUME_NONNULL_END
