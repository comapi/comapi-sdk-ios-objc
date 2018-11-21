//
//  CMPQueryProfilesTemplate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 12/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPQueryProfilesTemplate.h"

@implementation CMPQueryProfilesTemplate

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID token:(NSString *)token queryString:(NSString *)queryString {
    self = [super initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID];
    
    if (self) {
        self.token = token;
        self.queryString = queryString;
    }
    
    return self;
}

- (nullable NSData *)httpBody {
    return nil;
}

- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders {
    CMPHTTPHeader *contentType = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderContentType value:@"application/json"];
    CMPHTTPHeader *authorization = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderAuthorization value:[NSString stringWithFormat:@"%@ %@", @"Bearer", self.token]];
    return [NSSet setWithObjects:contentType, authorization, nil];
}

- (NSString *)httpMethod {
    return CMPHTTPMethodGET;
}

- (NSArray<NSString *> *)pathComponents {
    return @[@"apispaces", self.apiSpaceID, [NSString stringWithFormat:@"%@%@", @"profiles", self.queryString]];
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    return nil;
}

- (CMPResult<id> *)resultFromData:(NSData *)data urlResponse:(NSURLResponse *)response {
    NSInteger code = [response httpStatusCode];
    NSString *eTag = [[response httpURLResponse] allHeaderFields][@"ETag"];
    switch (code) {
        case 200: {
            NSError *parseError = nil;
            NSArray<NSDictionary *> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSMutableArray<CMPProfile *> *object = [NSMutableArray new];
            [json enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CMPProfile *profile = [[CMPProfile alloc] initWithJSON:obj];
                [object addObject:profile];
            }];
            
            return [[CMPResult alloc] initWithObject:object error:nil eTag:eTag code:code];
        }
        case 404: {
            NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorNotFound underlyingError:nil];
            return [[CMPResult alloc] initWithObject:nil error:error eTag:eTag code:code];
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
