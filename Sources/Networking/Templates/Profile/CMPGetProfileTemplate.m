//
//  CMPGetProfileTemplate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 11/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPGetProfileTemplate.h"

@implementation CMPGetProfileTemplate

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID profileID:(NSString *)profileID token:(NSString *)token {
    self = [super initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID];
    
    if (self) {
        self.profileID = profileID;
        self.token = token;
    }
    
    return self;
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    return nil;
}

- (nullable NSData *)httpBody {
    return nil;
}

- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders {
    CMPHTTPHeader *contentType = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderContentType value:@"application/json"];
    CMPHTTPHeader *authorization = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderAuthorization value: [NSString stringWithFormat:@"%@ %@", @"Bearer", self.token]];
    NSSet<CMPHTTPHeader *> *headers = [NSSet setWithObjects:contentType, authorization, nil];
    return headers;
}

- (NSString *)httpMethod {
    return CMPHTTPMethodGET;
}

- (NSArray<NSString *> *)pathComponents {
    return @[@"apispaces", self.apiSpaceID, @"profiles", self.profileID];
}

- (CMPRequestTemplateResult *)resultFromData:(NSData *)data urlResponse:(NSURLResponse *)response {
    if ([response httpStatusCode] == 200) {
        CMPProfile *object = [[CMPProfile alloc] decodeWithData:data];
        return [[CMPRequestTemplateResult alloc] initWithObject:object error:nil];
    } else if ([response httpStatusCode] == 404) {
        NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorNotFound underlyingError:nil];
        return [[CMPRequestTemplateResult alloc] initWithObject:nil error:error];
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
