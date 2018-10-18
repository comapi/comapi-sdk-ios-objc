//
//  CMPStartNewSessionTemplate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 23/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPStartNewSessionTemplate.h"
#import "CMPAuthenticationChallenge.h"

@implementation CMPStartNewSessionTemplate

- (nullable NSData *)httpBody {
    return nil;
}

- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders {
    CMPHTTPHeader *contentType = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderContentType value:@"application/json"];
    NSSet<CMPHTTPHeader *> *headers = [NSSet setWithObject:contentType];
    return headers;
}

- (nonnull NSString *)httpMethod {
    return CMPHTTPMethodGET;
}

- (nonnull NSArray<NSString *> *)pathComponents {
    return @[@"apispaces", self.apiSpaceID, @"sessions", @"start"];
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    return nil;
}

- (CMPRequestTemplateResult *)resultFromData:(NSData *)data urlResponse:(NSURLResponse *)response {
    if ([response httpStatusCode] == 200) {
        CMPAuthenticationChallenge *object = [[CMPAuthenticationChallenge alloc] decodeWithData:data];
        return [[CMPRequestTemplateResult alloc] initWithObject:object error:nil];
    }
    
    NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorUnexpectedStatusCode underlyingError:nil];
    return [[CMPRequestTemplateResult alloc] initWithObject:nil error:error];
}

- (void)performWithRequestPerformer:(id<CMPRequestPerforming>)performer result:(void (^)(CMPRequestTemplateResult *))result {
    NSURLRequest *request = [self requestFromHTTPRequestTemplate:self];
    if (!request) {
        NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorRequestCreationFailed underlyingError:nil];
        result([[CMPRequestTemplateResult alloc] initWithObject:nil error:error]);
        return;
    }

    [performer performRequest:request completion:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        result([self resultFromData:data urlResponse:response]);
    }];
}

@end
