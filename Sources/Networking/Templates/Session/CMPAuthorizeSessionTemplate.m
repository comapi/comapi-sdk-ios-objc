//
//  CMPAuthorizationSessionTemplate.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 23/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAuthorizeSessionTemplate.h"
#import "CMPSessionAuth.h"

@implementation CMPAuthorizeSessionTemplate

- (nullable NSData *)httpBody {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.body options:0 error:&error];
    if (!error) {
        return nil;
    }
    return data;
}

- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders {
    CMPHTTPHeader *contentType = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderContentType value:CMPHTTPHeaderContentTypeJSON];
    NSSet<CMPHTTPHeader *> *headers = [NSSet setWithObject:contentType];
    return headers;
}

- (nonnull NSString *)httpMethod {
    return CMPHTTPMethodPOST;
}

- (nonnull NSArray<NSString *> *)pathComponents {
    return @[@"apispaces", self.apiSpaceID, @"sessions"];
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    return nil;
}

- (nonnull CMPRequestTemplateResult *)resultFromData:(nonnull NSData *)data urlResponse:(nonnull NSURLResponse *)response {
    if ([response httpStatusCode] == 200) {
        NSError *parseError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (parseError) {
            NSError *error = [CMPErrors errorWithStatus:CMPRequestTemplateErrorResponseParsingFailed underlyingError:parseError];
            return [[CMPRequestTemplateResult alloc] initWithObject:nil error:error];
        }
        
        CMPSessionAuth *object = [[CMPSessionAuth alloc] initWithJSON:json];
        if (object) {
            return [[CMPRequestTemplateResult alloc] initWithObject:object error:nil];
        } else {
            NSError *error = [CMPErrors errorWithStatus:CMPRequestTemplateErrorResponseParsingFailed underlyingError:parseError];
            return [[CMPRequestTemplateResult alloc] initWithObject:nil error:error];
        }
    }
    
    NSError *error = [CMPErrors errorWithStatus:CMPRequestTemplateErrorUnauthorizedStatusCode underlyingError:nil];
    return [[CMPRequestTemplateResult alloc] initWithObject:nil error:error];
}

-(void)performWithRequestPerformer:(CMPRequestPerformer *)performer result:(void (^)(CMPRequestTemplateResult * _Nonnull))result {
    NSURLRequest *request = [self requestFromHTTPRequestTemplate:self];
    if (!request) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [CMPErrors errorWithStatus:CMPRequestTemplateErrorRequestCreationFailed underlyingError:nil];
            result([[CMPRequestTemplateResult alloc] initWithObject:nil error:error]);
        });
        return;
    }
    
    __weak CMPAuthorizeSessionTemplate *weakSelf = self;
    [performer performRequest:request completion:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            result([weakSelf resultFromData:data urlResponse:response]);
        });
    }];
}

@end
