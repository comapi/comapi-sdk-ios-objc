//
//  CMPSendMessagesTemplate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 09/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSendMessagesTemplate.h"
#import "CMPSendMessagesResult.h"

@implementation CMPSendMessagesTemplate

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID conversationID:(NSString *)conversationID message:(CMPSendableMessage *)message token:(NSString *)token {
    self = [super initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID];
    
    if (self) {
        self.conversationID = conversationID;
        self.message = message;
        self.token = token;
    }
    
    return self;
}

- (nullable NSData *)httpBody {
    return [self.message encode];
}

- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders {
    CMPHTTPHeader *contentType = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderContentType value:@"application/json"];
    CMPHTTPHeader *authorization = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderAuthorization value:[NSString stringWithFormat:@"Bearer %@", self.token]];
    return [NSSet setWithObjects:contentType, authorization, nil];
}

- (nonnull NSString *)httpMethod {
    return CMPHTTPMethodPOST;
}

- (nonnull NSArray<NSString *> *)pathComponents {
    return @[@"apispaces", self.apiSpaceID, @"conversations", self.conversationID, @"messages"];
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    return nil;
}

- (CMPResult<id> *)resultFromData:(NSData *)data urlResponse:(NSURLResponse *)response {
    NSInteger code = [response httpStatusCode];
    NSString *eTag = [[response httpURLResponse] allHeaderFields][@"ETag"];
    switch (code) {
        case 200: {
            CMPSendMessagesResult *object = [CMPSendMessagesResult decodeWithData:data];
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
