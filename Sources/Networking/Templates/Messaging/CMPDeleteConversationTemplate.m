//
//  CMPDeleteConversationTemplate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPDeleteConversationTemplate.h"

@implementation CMPDeleteConversationTemplate

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID conversationID:(NSString *)converstionID eTag:(NSString *)eTag token:(NSString *)token {
    self = [super initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID];
    
    if (self) {
        self.conversationID = converstionID;
        self.eTag = eTag;
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
    NSSet<CMPHTTPHeader *> *set = [NSSet setWithObjects:contentType, authorization, nil];
    if (self.eTag) {
        CMPHTTPHeader *eTag = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderIfMatch value:self.eTag];
        set = [set setByAddingObject:eTag];
    }
    return set;
}

- (nonnull NSString *)httpMethod {
    return CMPHTTPMethodDELETE;
}

- (nonnull NSArray<NSString *> *)pathComponents {
    return @[@"apispaces", self.apiSpaceID, @"conversations", self.conversationID];
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    return nil;
}

- (nonnull CMPRequestTemplateResult *)resultFromData:(nonnull NSData *)data urlResponse:(nonnull NSURLResponse *)response {
    if ([response httpStatusCode] == 200) {
        return [[CMPRequestTemplateResult alloc] initWithObject:[NSNumber numberWithBool:YES] error:nil];
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

//struct DeleteConversationTemplate: RequestTemplate {
//
//    var scheme: String
//    var host: String
//    var port: Int
//    var pathComponents: [String] { return ["apispaces", self.apiSpaceId, "conversations", conversationId] }
//    let query: [String : String]? = nil
//
//    let httpMethod: HTTPMethod = .delete
//    var httpHeaders: Set<HTTPHeader>? { var headers: Set<HTTPHeader> = [.contentType(.JSON), .authorization(token)]
//        if let ETag = ETag { headers.insert(.ifMatch(ETag))}
//        return  headers
//    }
//
//    let httpBody: Data? = nil
//
//    var apiSpaceId: String
//    var conversationId: String
//    var ETag: String? = nil
//    var token: String
//
//    static func result(from data: Data, urlResponse: URLResponse) -> Result<Bool, TemplateResultError> {
//        switch urlResponse.httpStatusCode {
//        case 200?: return .success(true)
//        case 404?: return .failure(.notFound)
//        case 409?: return .failure(.updateConflict)
//        default: return .failure(.unexpectedStatusCode)
//        }
//    }
//
//}
