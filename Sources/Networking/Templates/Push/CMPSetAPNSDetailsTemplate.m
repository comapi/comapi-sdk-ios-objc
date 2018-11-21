//
//  SetAPNSDetailsTemplate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 30/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSetAPNSDetailsTemplate.h"

@implementation CMPSetAPNSDetailsTemplate

-(instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID token:(NSString *)token sessionID:(NSString *)sessionID body:(CMPAPNSDetailsBody *)body {
    self = [super initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID];
    
    if (self) {
        self.token = token;
        self.sessionID = sessionID;
        self.body = body;
    }
    
    return self;
}

- (nullable NSData *)httpBody {
    return [self.body encode];
}

- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders {
    CMPHTTPHeader *contentType = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderContentType value:@"application/json"];
    CMPHTTPHeader *authorization = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderAuthorization value:[NSString stringWithFormat:@"%@ %@", @"Bearer", self.token]];
    NSSet<CMPHTTPHeader *> *headers = [NSSet setWithObjects:contentType, authorization, nil];
    return headers;
}

- (NSString *)httpMethod {
    return CMPHTTPMethodPUT;
}

- (NSArray<NSString *> *)pathComponents {
    return @[@"apispaces", self.apiSpaceID, @"sessions", self.sessionID, @"push"];
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    return nil;
}

- (CMPResult<id> *)resultFromData:(NSData *)data urlResponse:(NSURLResponse *)response {
    NSInteger code = [response httpStatusCode];
    NSString *eTag = [[response httpURLResponse] allHeaderFields][@"ETag"];
    switch (code) {
        case 200: {
            NSNumber *object = @(YES);
            return [[CMPResult alloc] initWithObject:object error:nil eTag:eTag code:code];
        }
        default: {
            NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorUnexpectedStatusCode underlyingError:nil];
            return [[CMPResult alloc] initWithObject:nil error:error eTag:eTag code:code];
        }
    }
}

- (void)performWithRequestPerformer:(id<CMPRequestPerforming>)performer result:(void (^)(CMPResult<id> *))result {
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
