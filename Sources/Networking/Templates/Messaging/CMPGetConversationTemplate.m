//
//  CMPGetConversationTemplate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPGetConversationTemplate.h"
#import "CMPConversation.h"

@implementation CMPGetConversationTemplate

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID conversationID:(NSString *)conversationID token:(NSString *)token {
    self = [super initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID];
    
    if (self) {
        self.conversationID = conversationID;
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
    return @[@"apispaces", self.apiSpaceID, @"conversations", self.conversationID];
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    return nil;
}

- (nonnull CMPRequestTemplateResult *)resultFromData:(nonnull NSData *)data urlResponse:(nonnull NSURLResponse *)response {
    if ([response httpStatusCode] == 200) {
        return [[CMPRequestTemplateResult alloc] initWithObject:[[CMPConversation alloc] decodeWithData:data] error:nil];
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

//struct GetConversationTemplate : RequestTemplate {
//    var scheme: String
//    var host: String
//    var port: Int
//    var pathComponents: [String] { return ["apispaces", self.apiSpaceId, "conversations", conversationId] }
//    let query: [String : String]? = nil
//
//    let httpMethod: HTTPMethod = .get
//    var httpHeaders: Set<HTTPHeader>? { return [.contentType(.JSON), .authorization(token)] }
//    let httpBody: Data? = nil
//
//    // MARK: -
//
//    var apiSpaceId: String
//    var conversationId: String
//    var token: String
//
//    static func result(from data: Data, urlResponse: URLResponse) -> Result<Conversation, TemplateResultError> {
//        switch urlResponse.httpStatusCode {
//        case 200?:
//            do {
//                let json: Conversation.JSON = try JSONDecoder.default().decode(Conversation.JSON.self, from: data)
//                return try .success(Conversation.from(json))
//            }
//            catch {
//                return .failure(.unexpectedJSON)
//            }
//        case 404?: return .failure(.notFound)
//        default:
//            return .failure(.unexpectedStatusCode)
//        }
//        }
