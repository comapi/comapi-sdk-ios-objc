//
//  CMPHTTPRequestTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 29/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplateResult.h"
#import "CMPUtilities.h"

@protocol CMPHTTPRequestTemplate

- (NSArray<NSString *> *)pathComponents;
- (nullable NSDictionary<NSString *, NSString *> *) query;
- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders;
- (nullable NSData *)httpBody;
- (NSString *)httpMethod;

- (void)performWithRequestPerformer:(id<CMPRequestPerforming>)performer result:(void(^)(CMPRequestTemplateResult *))result;
- (CMPRequestTemplateResult *)resultFromData:(NSData *)data urlResponse:(NSURLResponse *)response;

@end
