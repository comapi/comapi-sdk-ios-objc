//
//  CMPURLResult.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 17/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(URLResult)
@interface CMPURLResult : NSObject

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, nullable) NSData *data;
@property (nonatomic, nullable) NSURLResponse *response;
@property (nonatomic, nullable) NSError *error;

- (instancetype)initWithRequest:(NSURLRequest *)request data:(NSData * _Nullable)data response:(NSURLResponse * _Nullable)response error:(NSError * _Nullable)error;

- (NSString *)description;

@end

NS_ASSUME_NONNULL_END
