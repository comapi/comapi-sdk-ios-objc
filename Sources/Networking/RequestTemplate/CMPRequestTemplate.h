//
//  RequestTemplate.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 17/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPHTTPHeader.h"
#import "CMPErrors.h"
#import "CMPConstants.h"
#import "NSURLResponse+CMPUtility.h"
#import "CMPRequestPerformer.h"

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

- (void)performWithRequestPerformer:(CMPRequestPerformer *)performer result:(void(^)(CMPRequestTemplateResult *))result;
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
- (NSURLRequest *)requestFromHTTPRequestTemplate:(id<CMPHTTPRequestTemplate>)template;

@end



NS_ASSUME_NONNULL_END

