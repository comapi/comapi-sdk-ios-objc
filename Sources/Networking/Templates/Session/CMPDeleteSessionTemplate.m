//
//  CMPDeleteSessionTemplate.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 27/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPDeleteSessionTemplate.h"

@implementation CMPDeleteSessionTemplate

-(instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port token:(NSString *)token sessionID:(NSString *)sessionID {
    self = [super initWithScheme:scheme host:host port:port];
    
    if (self) {
        self.token = token;
        self.sessionID = sessionID;
    }
    
    return self;
}
//    var scheme: String
//    var host: String
//    var port: Int
//    var pathComponents: [String] { return ["apispaces", self.apiSpaceId, "sessions", sessionID] }
//    let query: [String : String]? = nil
//
//    let httpMethod: HTTPMethod = .delete
//    var httpHeaders: Set<HTTPHeader>? { return [.contentType(.JSON), .authorization(token)] }
//    let httpBody: Data? = nil
//
//    var apiSpaceId: String
//    var sessionID: String
//    var token: String
//
//    static func result(from data: Data, urlResponse: URLResponse) -> Result<Bool, TemplateResultError> {
//        switch urlResponse.httpStatusCode {
//        case 204?: return .success(true)
//        default: return .failure(.unexpectedStatusCode)
//        }
//    }
- (nullable NSData *)httpBody {
    return nil;
}

- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders {
    CMPHTTPHeader *contentType = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderContentType value:CMPHTTPHeaderContentTypeJSON];
    CMPHTTPHeader *authorization = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderAuthorization value:self.token];
    NSSet<CMPHTTPHeader *> *headers = [NSSet setWithObjects:contentType, authorization, nil];
    return headers;
}

- (nonnull NSString *)httpMethod {
    return CMPHTTPMethodDELETE;
}

- (nonnull NSArray<NSString *> *)pathComponents {
    return @[@"apispaces", self.apiSpaceID, @"sessions", self.sessionID];
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    return nil;
}

- (nonnull CMPRequestTemplateResult *)resultFromData:(nonnull NSData *)data urlResponse:(nonnull NSURLResponse *)response {
    if ([response httpStatusCode] == 204) {
        NSNumber *object = @(YES);
        return [[CMPRequestTemplateResult alloc] initWithObject:object error:nil];
    }
    
    NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorUnauthorizedStatusCode underlyingError:nil];
    return [[CMPRequestTemplateResult alloc] initWithObject:nil error:error];
}

- (void)performWithRequestPerformer:(nonnull CMPRequestPerformer *)performer result:(nonnull void (^)(CMPRequestTemplateResult * _Nonnull))result {
    NSURLRequest *request = [self requestFromHTTPRequestTemplate:self];
    if (!request) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorRequestCreationFailed underlyingError:nil];
            result([[CMPRequestTemplateResult alloc] initWithObject:nil error:error]);
        });
        return;
    }
    
    __weak CMPDeleteSessionTemplate *weakSelf = self;
    [performer performRequest:request completion:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            result([weakSelf resultFromData:data urlResponse:response]);
        });
    }];
}

@end
