//
//  CMPHTTPRequestTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 29/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplateResult.h"
#import "CMPUtilities.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(HTTPRequestTemplate)
@protocol CMPHTTPRequestTemplate <NSObject>

@required
- (NSString *)httpMethod;
- (NSArray<NSString *> *)pathComponents;
- (nullable NSDictionary<NSString *, NSString *> *) query;
- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders;
- (nullable NSData *)httpBody;

- (CMPRequestTemplateResult *)resultFromData:(NSData *)data urlResponse:(NSURLResponse *)response;
- (void)performWithRequestPerformer:(id<CMPRequestPerforming>)performer result:(void(^)(CMPRequestTemplateResult *))result;

@optional
- (nullable NSInputStream *)httpBodyStream;

@end

NS_ASSUME_NONNULL_END
