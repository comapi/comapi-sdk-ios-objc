//
//  CMPGetConversationsTemplate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPGetConversationsTemplate.h"
#import "CMPConversation.h"

@interface CMPGetConversationsTemplate ()

- (NSString *)stringForConversationScope:(CMPConversationScope)scope;

@end

@implementation CMPGetConversationsTemplate

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID profileID:(NSString *)profileID scope:(CMPConversationScope)scope token:(NSString *)token {
    self = [super initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID];
    
    if (self) {
        self.conversationScope = scope;
        self.profileID = profileID;
        self.token = token;
    }
    
    return self;
}

- (NSString *)stringForConversationScope:(CMPConversationScope)scope {
    switch (scope) {
        case CMPConversationScopePublic:
            return @"public";
        case CMPConversationScopeParticipant:
            return @"participant";
    }
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
    if (self.conversationScope != CMPConversationScopeParticipant) {
        query[@"scope"] = [self stringForConversationScope:self.conversationScope];
    }
    if (self.profileID) {
        query[@"profileId"] = self.profileID;
    }
    return query;
}

- (CMPResult<id> *)resultFromData:(NSData *)data urlResponse:(NSURLResponse *)response {
    NSInteger code = [response httpStatusCode];
    NSString *eTag = [[response httpURLResponse] allHeaderFields][@"ETag"];
    switch (code) {
        case 200: {
            __block NSError *parseError = nil;
            NSArray<NSDictionary<NSString *, id> *> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            if (parseError) {
                NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorResponseParsingFailed underlyingError:parseError];
                return [[CMPResult alloc] initWithObject:nil error:error eTag:eTag code:code];
            }
            NSMutableArray<CMPConversation *> *conversations = [NSMutableArray new];
            
            [json enumerateObjectsUsingBlock:^(NSDictionary<NSString *, id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [conversations addObject:[CMPConversation decodeWithData:[NSJSONSerialization dataWithJSONObject:obj options:0 error:&parseError]]];
            }];
            
            NSArray<CMPConversation *> *object = [NSArray arrayWithArray:conversations];
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
