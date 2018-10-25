//
//  CMPGetConversationsTemplate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPGetConversationsTemplate.h"
#import "CMPConversation.h"

@implementation CMPGetConversationsTemplate

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID profileID:(NSString *)profileID scope:(NSString *)scope token:(NSString *)token {
    self = [super initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID];
    
    if (self) {
        self.conversationScope = scope;
        self.profileID = profileID;
        self.token = token;
    }
    
    return self;
}

- (nullable NSData *)httpBody { 
    return nil;
}

- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders { 
    CMPHTTPHeader *contentType = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderContentType value:@"application/json"];
    CMPHTTPHeader *authorization = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderAuthorization value:[NSString stringWithFormat:@"Bearer %@", self.token]];
    return [NSSet setWithObjects:contentType, authorization, nil];
}

- (nonnull NSString *)httpMethod { 
    return CMPHTTPMethodGET;
}

- (nonnull NSArray<NSString *> *)pathComponents { 
    return @[@"apispaces", self.apiSpaceID, @"conversations"];
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    NSMutableDictionary<NSString *, NSString *> *query = [NSMutableDictionary new];
    if (self.conversationScope) {
        query[@"scope"] = self.conversationScope;
    }
    if (self.profileID) {
        query[@"profileId"] = self.profileID;
    }
    return query;
}

- (nonnull CMPRequestTemplateResult *)resultFromData:(nonnull NSData *)data urlResponse:(nonnull NSURLResponse *)response { 
    if ([response httpStatusCode] == 200) {
        __block NSError *parseError = nil;
        NSArray<NSDictionary<NSString *, id> *> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (parseError) {
            NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorResponseParsingFailed underlyingError:parseError];
            return [[CMPRequestTemplateResult alloc] initWithObject:nil error:error];
        }
        NSMutableArray<CMPConversation *> *conversations = [NSMutableArray new];
        
        [json enumerateObjectsUsingBlock:^(NSDictionary<NSString *, id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [conversations addObject:[CMPConversation decodeWithData:[NSJSONSerialization dataWithJSONObject:obj options:0 error:&parseError]]];
        }];

        return [[CMPRequestTemplateResult alloc] initWithObject:conversations error:nil];
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
