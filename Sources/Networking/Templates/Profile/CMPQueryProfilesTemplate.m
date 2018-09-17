//
//  CMPQueryProfilesTemplate.m
//  comapi-ios-sdk-objective-c
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
    CMPHTTPHeader *contentType = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderContentType value:CMPHTTPHeaderContentTypeJSON];
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

- (CMPRequestTemplateResult *)resultFromData:(NSData *)data urlResponse:(NSURLResponse *)response {
    if ([response httpStatusCode] == 200) {
        NSError *parseError = nil;
        NSArray<NSDictionary *> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        NSMutableArray<CMPProfile *> *object = [NSMutableArray new];
        [json enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CMPProfile *profile = [[CMPProfile alloc] initWithJSON:obj];
            [object addObject:profile];
        }];
        
        if (object) {
            return [[CMPRequestTemplateResult alloc] initWithObject:object error:nil];
        } else {
            NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorResponseParsingFailed underlyingError:parseError];
            return [[CMPRequestTemplateResult alloc] initWithObject:nil error:error];
        }
    }
    
    NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorUnexpectedStatusCode underlyingError:nil];
    return [[CMPRequestTemplateResult alloc] initWithObject:nil error:error];
}

- (void)performWithRequestPerformer:(CMPRequestPerformer *)performer result:(void (^)(CMPRequestTemplateResult *))result {
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
