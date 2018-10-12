//
//  CMPGetMessagesTemplate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPGetMessagesTemplate.h"

@implementation CMPGetMessagesTemplate

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID conversationID:(NSString *)conversationID from:(NSUInteger)from limit:(NSUInteger)limit token:(NSString *)token {
    self = [super initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID];
    
    if (self) {
        self.conversationID = conversationID;
        self.from = from;
        self.limit = limit;
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
    return @[@"apispaces", self.apiSpaceID, @"conversations", self.conversationID, @"messages"];
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    NSMutableDictionary<NSString *, NSString *> *query = [NSMutableDictionary new];
    query[@"limit"] = [NSString stringWithFormat:@"%lu", (unsigned long)self.limit];
    if (self.from > 0) {
        query[@"from"] = [NSString stringWithFormat:@"%lu", (unsigned long)self.from];
    }
    return query;
}

- (nonnull CMPRequestTemplateResult *)resultFromData:(nonnull NSData *)data urlResponse:(nonnull NSURLResponse *)response {
    if ([response httpStatusCode] == 200) {
        return [[CMPRequestTemplateResult alloc] initWithObject:[NSNumber numberWithBool:YES] error:nil];
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

//struct GetMessagesTemplate: RequestTemplate {
//    var scheme: String
//    var host: String
//    var port: Int
//    var pathComponents: [String] {
//        return ["apispaces", self.apiSpaceId, "conversations", self.conversationId, "messages"]
//    }
//    var query: [String : String]? {
//        var query: [String: String] = [:]
//        query["limit"] = String(limit)
//        if let from = from { query["from"] = String(from) }
//        return query
//    }
//
//    let httpMethod: HTTPMethod = .get
//    var httpHeaders: Set<HTTPHeader>? { return [.contentType(.JSON), .authorization(self.token)] }
//    let httpBody: Data? = nil
//
//    var apiSpaceId: String
//    var conversationId: String
//    var from: Int?
//    var limit: Int
//    var token: String
//
//    static func result(from data: Data, urlResponse: URLResponse) -> Result<GetMessagesResult, TemplateResultError> {
//        switch urlResponse.httpStatusCode {
//        case 200?:
//            return .success(GetMessagesResult(fromData:data))
//        default:
//            return .failure(.unexpectedStatusCode)
//        }
//    }
//}
