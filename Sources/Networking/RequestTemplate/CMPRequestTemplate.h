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

@protocol CMPHTTPRequestTemplate

- (NSString *)scheme;
- (NSString *)host;
- (NSUInteger)port;
- (NSArray<NSString *> *)pathComponents;
- (NSDictionary<NSString *, NSString *> * _Nullable) query;
- (NSSet<CMPHTTPHeader *> *)httpHeaders;
- (NSData *)httpBody;
- (NSString *)httpMethod;

+ (id)resultFrom:(NSData *)data response:(NSURLResponse *)response ofType:(Class)type;

@end

@protocol CMPStreamRequestTemplate

- (NSInputStream * _Nullable)httpBodyStream;

@end

@interface CMPRequestTemplate : NSObject

- (NSURLRequest * _Nullable)requestFromHTTPTemplate:(id<CMPHTTPRequestTemplate>)template;

@end

@interface CMPRequestTemplateResult : NSObject

@property (nonatomic, nullable) id object;
@property (nonatomic, nullable) NSError *error;

@end

NS_ASSUME_NONNULL_END

