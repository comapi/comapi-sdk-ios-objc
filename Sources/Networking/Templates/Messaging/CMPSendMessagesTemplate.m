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
    CMPHTTPHeader *authorization = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderAuthorization value:self.token];
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

- (nonnull CMPRequestTemplateResult *)resultFromData:(nonnull NSData *)data urlResponse:(nonnull NSURLResponse *)response {
    if ([response httpStatusCode] == 200) {
        CMPSendMessagesResult *result = [[CMPSendMessagesResult alloc] decodeWithData:data];
        return [[CMPRequestTemplateResult alloc] initWithObject:result error:nil];
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

//struct PostMessagesTemplate: RequestTemplate {
//var scheme: String
//var host: String
//var port: Int
//var pathComponents: [String] {
//return ["apispaces", self.apiSpaceId, "conversations", self.conversationId, "messages"]
//}
//let query: [String : String]? = nil
//
//let httpMethod: HTTPMethod = .post
//var httpHeaders: Set<HTTPHeader>? { return [.contentType(.JSON), .authorization(self.token)] }
//var httpBody: Data? { return try? JSONEncoder.default().encode(self.message) }
//
//var apiSpaceId: String
//var conversationId: String
//var message: SendableMessage
//var token: String
//
//static func result(from data: Data, urlResponse: URLResponse) -> Result<PostMessagesResult, TemplateResultError> {
//switch urlResponse.httpStatusCode {
//case 200?:
//
//do {
//return try .success(PostMessagesResult.from(JSONDecoder.default().decode(PostMessagesResult.JSON.self, from: data)))
//}
//catch {
//return .failure(.unexpectedJSON)
//}
//
//default:
//return .failure(.unexpectedStatusCode)
//}
//}
//}
