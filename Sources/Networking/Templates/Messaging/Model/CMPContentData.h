//
//  CMPContentData.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 09/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONEncoding.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ContentData)
@interface CMPContentData : NSObject <CMPJSONEncoding>

@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSString *type;
@property (nonatomic, strong, nullable) NSData *data;

- (instancetype)initWithData:(NSData *)data type:(nullable NSString *)type name:(nullable NSString *)name;
- (instancetype)initWithUrl:(NSURL *)url type:(nullable NSString *)type name:(nullable NSString *)name;
- (instancetype)initWithBase64Data:(NSString *)data type:(nullable NSString *)type name:(nullable NSString *)name;

@end

NS_ASSUME_NONNULL_END
