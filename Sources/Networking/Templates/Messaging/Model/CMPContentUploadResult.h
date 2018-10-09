//
//  CMPContentUploadResult.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 09/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPContentUploadResult : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSString *type;
@property (nonatomic, strong, nullable) NSNumber *size;
@property (nonatomic, strong, nullable) NSString *folder;
@property (nonatomic, strong, nullable) NSURL *url;

- (instancetype)initWithID:(nullable NSString *)ID type:(nullable NSString *)type size:(nullable NSNumber *)size folder:(nullable NSString *)folder url:(nullable NSURL *)url;

@end

NS_ASSUME_NONNULL_END
