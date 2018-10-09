//
//  CMPRequestTemplate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 20/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"
#import "CMPUtilities.h"

@implementation CMPRequestTemplate

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID {
    self = [super init];
    
    if (self) {
        self.scheme = scheme;
        self.host = host;
        self.port = port;
        self.apiSpaceID = apiSpaceID;
    }
    
    return self;
}

- (NSURLComponents *)componentsFromURLTemplate:(id<CMPHTTPRequestTemplate>)template {
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.host = self.host;
    components.scheme = self.scheme;
    components.port = @(self.port);
    components.path = [NSString stringWithFormat:@"/%@", [template.pathComponents componentsJoinedByString:@"/"]];

    if (template.query != nil && template.query.allKeys.count > 0) {
        NSMutableArray<NSURLQueryItem *> *items = [[NSMutableArray alloc] init];
        [template.query enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            NSURLQueryItem *item = [[NSURLQueryItem alloc] initWithName:key value:obj];
            [items addObject:item];
        }];
        components.queryItems = items;
    }

    return components;
}

- (NSURLRequest *)requestFromHTTPRequestTemplate:(id<CMPHTTPRequestTemplate>)template {
    NSURLComponents *components = [self componentsFromURLTemplate:template];
    if (components.URL != nil) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:components.URL];
        request.HTTPMethod = template.httpMethod;
        request.HTTPBody = template.httpBody;
        request.HTTPBodyStream = template.httpBodyStream;
        [template.httpHeaders enumerateObjectsUsingBlock:^(CMPHTTPHeader * _Nonnull obj, BOOL * _Nonnull stop) {
            [request setValue:obj.value forHTTPHeaderField:obj.field];
        }];

        return request;
    }

    return nil;
}

@end
