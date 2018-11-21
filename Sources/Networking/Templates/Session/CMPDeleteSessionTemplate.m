//
//  CMPDeleteSessionTemplate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 27/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPDeleteSessionTemplate.h"

@implementation CMPDeleteSessionTemplate

- (instancetype) initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID token:(NSString *)token sessionID:(NSString *)sessionID {
    self = [super initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID];
    
    if (self) {
        self.token = token;
        self.sessionID = sessionID;
    }
    
    return self;
}

- (nullable NSData *)httpBody {
    return nil;
}

- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders {
    CMPHTTPHeader *contentType = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderContentType value:@"application/json"];
    CMPHTTPHeader *authorization = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderAuthorization value:[NSString stringWithFormat:@"%@ %@", @"Bearer", self.token]];
    NSSet<CMPHTTPHeader *> *headers = [NSSet setWithObjects:contentType, authorization, nil];
    return headers;
}

- (nonnull NSString *)httpMethod {
    return CMPHTTPMethodDELETE;
}

- (nonnull NSArray<NSString *> *)pathComponents {
    return @[@"apispaces", self.apiSpaceID, @"sessions", self.sessionID];
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    return nil;
}

- (nonnull CMPResult<id> *)resultFromData:(nonnull NSData *)data urlResponse:(nonnull NSURLResponse *)response {
    NSString *eTag = [[response httpURLResponse] allHeaderFields][@"ETag"];
    NSInteger code = [response httpStatusCode];
    switch (code) {
        case 204: {
            NSNumber *object = @(YES);
            return [[CMPResult alloc] initWithObject:object error:nil eTag:eTag code:code];
        }
        default: {
            NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorUnexpectedStatusCode underlyingError:nil];
            return [[CMPResult alloc] initWithObject:nil error:error eTag:eTag code:code];
        }
    }
}

- (void)performWithRequestPerformer:(id<CMPRequestPerforming>)performer result:(nonnull void (^)(CMPResult<id> * _Nonnull))result {
    NSURLRequest *request = [self requestFromHTTPRequestTemplate:self];
    if (!request) {
        NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorRequestCreationFailed underlyingError:nil];
        result([[CMPResult alloc] initWithObject:nil error:error eTag:nil code:error.code]);
        return;
    }
    
    [performer performRequest:request completion:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        result([self resultFromData:data urlResponse:response]);
    }];
}

@end
