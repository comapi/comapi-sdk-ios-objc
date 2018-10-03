//
//  CMPAPIConfiguration.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(APIConfiguration)
@interface CMPAPIConfiguration : NSObject

@property (nonatomic, strong) NSString* scheme;
@property (nonatomic, strong) NSString* host;
@property (nonatomic) NSUInteger port;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port;
+ (instancetype)production;

@end

NS_ASSUME_NONNULL_END
