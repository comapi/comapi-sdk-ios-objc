//
//  CMPContentUploadTemplate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 09/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPContentUploadTemplate.h"
#import "CMPContentUploadResult.h"

@implementation CMPContentUploadTemplate

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID content:(CMPContentData *)content folder:(NSString *)folder token:(NSString *)token {
    self = [super initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID];
    
    if (self) {
        self.content = content;
        self.folder = folder;
        self.token = token;
    }
    
    return self;
}

- (nullable NSInputStream *)httpBodyStream {
    return [NSInputStream inputStreamWithData:[self.content encode]];
}

- (nullable NSData *)httpBody {
    return nil;
}

- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders {
    CMPHTTPHeader *contentFilename = [[CMPHTTPHeader alloc] initWithField:@"Content-Filename" value:self.content.name ? self.content.name : @""];
    CMPHTTPHeader *contentType = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderContentType value:@"application/json"];
    CMPHTTPHeader *authorization = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderAuthorization value:self.token];
    return [NSSet setWithObjects:contentFilename, contentType, authorization, nil];
}

- (nonnull NSString *)httpMethod {
    return CMPHTTPMethodPOST;
}

- (nonnull NSArray<NSString *> *)pathComponents {
    return @[@"apispaces", self.apiSpaceID, @"content"];
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    if (self.folder) {
        return @{@"folder" : self.folder};
    }
    return nil;
}

- (nonnull CMPRequestTemplateResult *)resultFromData:(nonnull NSData *)data urlResponse:(nonnull NSURLResponse *)response {
    if ([response httpStatusCode] == 200) {
        CMPContentUploadResult *result = [[CMPContentUploadResult alloc] decodeWithData:data];
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

//struct ContentUploadTemplate : RequestTemplate, StreamRequestTemplate {
//    var scheme: String
//    var host: String
//    var port: Int
//    var pathComponents: [String] { return ["apispaces", self.apiSpaceId, "content"] }
//    var query: [String : String]? {
//        guard let folder = self.folder else { return nil }
//        return ["folder" : folder]
//    }
//
//    let httpMethod: HTTPMethod = .post
//    var httpHeaders: Set<HTTPHeader>? {
//        var headers: Set<HTTPHeader> = [.contentType(.JSON), .authorization(token)]
//        if let additionalHeaders = additionalHeaders { headers = headers.union(additionalHeaders) }
//        return headers
//    }
//
//    var httpBody: Data? {
//        return nil
//    }
//
//    var httpBodyStream: InputStream? {
//        guard let json = try? JSONEncoder.default().encode(content) else { return nil }
//        return InputStream(data: json)
//    }
//
//    var apiSpaceId: String
//    var content: ContentData
//    var folder: String?
//    var token: String
//
//    var additionalHeaders: Set<HTTPHeader>? {
//        let headers: Set<HTTPHeader> = [.custom(field: "Content-Filename", value: content.name ?? "")]
//        return headers
//    }
//
//    static func result(from data: Data, urlResponse: URLResponse) -> Result<ContentUploadResult, TemplateResultError> {
//        switch urlResponse.httpStatusCode {
//        case 200?:
//            do {
//                return try .success(ContentUploadResult.from(JSONDecoder.default().decode(ContentUploadResult.JSON.self, from: data)))
//            } catch {
//                return .failure(.validationError)
//            }
//        case 400?:
//            return .failure(.validationError)
//        case 404?:
//            return .failure(.notFound)
//        default:
//            return .failure(.unexpectedStatusCode)
//        }
//    }
//}
