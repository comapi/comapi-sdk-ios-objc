//
//  CMPHTTPRequestTemplate.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 29/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPRequestTemplateResult.h"

@protocol CMPHTTPRequestTemplate

- (NSArray<NSString *> *)pathComponents;
- (nullable NSDictionary<NSString *, NSString *> *) query;
- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders;
- (nullable NSData *)httpBody;
- (NSString *)httpMethod;

- (void)performWithRequestPerformer:(id<CMPRequestPerforming>)performer result:(void(^)(CMPRequestTemplateResult *))result;
- (CMPRequestTemplateResult *)resultFromData:(NSData *)data urlResponse:(NSURLResponse *)response;

@end
