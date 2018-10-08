//
//  CMPAddConversationTemplate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAddConversationTemplate.h"
#import "CMPConversation.h"

@implementation CMPAddConversationTemplate

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID conversation:(CMPNewConversation *)conversation token:(NSString *)token {
    self = [super initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID];
    
    if (self) {
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
    CMPHTTPHeader *authorization = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderAuthorization value:self.token];
    return [NSSet setWithObjects:contentType, authorization, nil];
}

- (nonnull NSString *)httpMethod {
    return CMPHTTPMethodPOST;
}

- (nonnull NSArray<NSString *> *)pathComponents {
    return @[@"apispaces", self.apiSpaceID, @"conversations"];
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    return nil;
}

- (nonnull CMPRequestTemplateResult *)resultFromData:(nonnull NSData *)data urlResponse:(nonnull NSURLResponse *)response {
    if ([response httpStatusCode] == 201) {
        CMPConversation *object = [[CMPConversation alloc] decodeWithData:data];
        return [[CMPRequestTemplateResult alloc] initWithObject:object error:nil];
    } else if ([response httpStatusCode] == 409) {
        NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorAlreadyExists underlyingError:nil];
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

//struct PostConversationsTemplate: RequestTemplate {
//    var scheme: String
//    var host: String
//    var port: Int
//    var pathComponents: [String] {
//        return ["apispaces", self.apiSpaceId, "conversations"]
//    }
//    let query: [String : String]? = nil
//
//    let httpMethod: HTTPMethod = .post
//    var httpHeaders: Set<HTTPHeader>? { return [.contentType(.JSON), .authorization(self.token)] }
//    var httpBody: Data? { return try? JSONEncoder.default().encode(self.conversation) }
//
//    var apiSpaceId: String
//    var conversation: NewConversation
//    var token: String
//
//    static func result(from data: Data, urlResponse: URLResponse) -> Result<Conversation, TemplateResultError> {
//        switch urlResponse.httpStatusCode {
//        case 201?:
//            do {
//                return try .success(Conversation.from(JSONDecoder.default().decode(Conversation.JSON.self, from: data)))
//            } catch {
//                return .failure(.unexpectedJSON)
//            }
//        case 409?: return .failure(.alreadyExist)
//        default: return .failure(.unexpectedStatusCode)
//        }
//    }
//}
