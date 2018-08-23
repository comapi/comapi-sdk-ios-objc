//
//  RequestTemplate.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 17/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CMPHTTPHeader.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMPRequestTemplateResult : NSObject

@property (nonatomic, nullable) id object;
@property (nonatomic, nullable) NSError *error;

- (instancetype)initWithObject:(nullable id)object error:(nullable NSError *)error;

@end

@protocol CMPHTTPRequestTemplate

- (NSArray<NSString *> *)pathComponents;
- (nullable NSDictionary<NSString *, NSString *> *) query;
- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders;
- (nullable NSData *)httpBody;
- (NSString *)httpMethod;

- (CMPRequestTemplateResult *)resultFromData:(NSData *)data urlResponse:(NSURLResponse *)response;

@end

@protocol CMPStreamRequestTemplate

- (nullable NSInputStream *)httpBodyStream;

@end

@interface CMPRequestTemplate : NSObject

@property (nonatomic, strong) NSString *apiSpaceID;
@property (nonatomic, strong) NSString *scheme;
@property (nonatomic, strong) NSString *host;
@property (nonatomic) NSUInteger port;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port;

@end



NS_ASSUME_NONNULL_END

