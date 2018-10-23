//
//  CMPUpdateConversationTemplate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPUpdateConversationTemplate.h"
#import "CMPConversation.h"

@implementation CMPUpdateConversationTemplate

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID conversationID:(NSString *)conversationID eTag:(NSString *)eTag conversation:(CMPConversationUpdate *)conversation token:(NSString *)token {
    self = [super initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID];
    
    if (self) {
        self.conversationID = conversationID;
        self.eTag = eTag;
        self.conversation = conversation;
        self.token = token;
    }
    
    return self;
}

- (nullable NSData *)httpBody {
    return [self.conversation encode];
}

- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders {
    CMPHTTPHeader *contentType = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderContentType value:@"application/json"];
    CMPHTTPHeader *authorization = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderAuthorization value:[NSString stringWithFormat:@"Bearer %@", self.token]];
    NSSet<CMPHTTPHeader *> *set = [NSSet setWithObjects:contentType, authorization, nil];
    if (self.eTag) {
        CMPHTTPHeader *eTag = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderIfMatch value:self.eTag];
        set = [set setByAddingObject:eTag];
    }
    return set;
}

- (nonnull NSString *)httpMethod {
    return CMPHTTPMethodPUT;
}

- (nonnull NSArray<NSString *> *)pathComponents {
    return @[@"apispaces", self.apiSpaceID, @"conversations", self.conversationID];
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    return nil;
}

- (nonnull CMPRequestTemplateResult *)resultFromData:(nonnull NSData *)data urlResponse:(nonnull NSURLResponse *)response {
    if ([response httpStatusCode] == 200) {
        CMPConversation *object = [[CMPConversation alloc] decodeWithData:data];
        return [[CMPRequestTemplateResult alloc] initWithObject:object error:nil];
    } else if ([response httpStatusCode] == 409) {
        NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorUpdateConflict underlyingError:nil];
        return [[CMPRequestTemplateResult alloc] initWithObject:nil error:error];
    } else if ([response httpStatusCode] == 404) {
        NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorNotFound underlyingError:nil];
        return [[CMPRequestTemplateResult alloc] initWithObject:nil error:error];
    }
    
    NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorUnexpectedStatusCode underlyingError:nil];
    return [[CMPRequestTemplateResult alloc] initWithObject:nil error:error];
}

- (void)performWithRequestPerformer:(nonnull id<CMPRequestPerforming>)performer result:(nonnull void (^)(CMPRequestTemplateResult * _Nonnull))result {
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
