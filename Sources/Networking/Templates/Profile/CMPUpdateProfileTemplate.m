//
//  CMPUpdateProfileTemplate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 12/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPUpdateProfileTemplate.h"

@implementation CMPUpdateProfileTemplate

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID profileID:(NSString *)profileID token:(NSString *)token eTag:(NSString *)eTag attributes:(NSDictionary<NSString *,NSString *> *)attributes {
    self = [super initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID];
    
    if (self) {
        self.token = token;
        self.profileID = profileID;
        self.eTag = eTag;
        self.attributes = attributes;
    }
    
    return self;
}

- (nullable NSData *)httpBody {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.attributes options:0 error:&error];
    if (error) {
        return nil;
    }
    return data;
}

- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders {
    NSMutableSet<CMPHTTPHeader *> *headers = [NSMutableSet set];
    CMPHTTPHeader *contentType = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderContentType value:@"application/json"];
    CMPHTTPHeader *authorization = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderAuthorization value:[NSString stringWithFormat:@"%@ %@", @"Bearer", self.token]];
    if (self.eTag) {
        CMPHTTPHeader *ifMatch = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderIfMatch value:self.eTag];
        [headers addObject:ifMatch];
    }
    [headers addObject:contentType];
    [headers addObject:authorization];
    return headers;
}

- (NSString *)httpMethod {
    return CMPHTTPMethodPUT;
}

- (NSArray<NSString *> *)pathComponents {
    return @[@"apispaces", self.apiSpaceID, @"profiles", self.profileID];
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    return nil;
}

- (CMPRequestTemplateResult *)resultFromData:(NSData *)data urlResponse:(NSURLResponse *)response {
    if ([response httpStatusCode] == 200) {
        CMPProfile *object = [CMPProfile decodeWithData:data];
        if (object) {
            return [[CMPRequestTemplateResult alloc] initWithObject:object error:nil];
        } else {
            NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorResponseParsingFailed underlyingError:nil];
            return [[CMPRequestTemplateResult alloc] initWithObject:nil error:error];
        }
    } else if ([response httpStatusCode] == 404) {
        NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorNotFound underlyingError:nil];
        return [[CMPRequestTemplateResult alloc] initWithObject:nil error:error];
    } else if ([response httpStatusCode] == 409) {
        NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorUpdateConflict underlyingError:nil];
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
