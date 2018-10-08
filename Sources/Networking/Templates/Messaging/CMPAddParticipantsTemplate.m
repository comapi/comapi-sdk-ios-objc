//
//  CMPAddParticipantsTemplate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAddParticipantsTemplate.h"

@implementation CMPAddParticipantsTemplate

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID conversationID:(NSString *)conversationID participants:(NSArray<CMPConversationParticipant *> *)participants token:(NSString *)token {
    self = [super initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID];
    
    if (self) {
        self.conversationID = conversationID;
        self.participants = participants;
        self.token = token;
    }
    
    return self;
}

- (nullable NSData *)httpBody {
    NSMutableArray<NSDictionary<NSString *, id> *> *json = [NSMutableArray new];
    [self.participants enumerateObjectsUsingBlock:^(CMPConversationParticipant * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [json addObject:[obj json]];
    }];
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
    if (error) {
        return nil;
    }
    return data;
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
    return @[@"apispaces", self.apiSpaceID, @"conversations", self.conversationID, @"participants"];
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    return nil;
}

- (nonnull CMPRequestTemplateResult *)resultFromData:(nonnull NSData *)data urlResponse:(nonnull NSURLResponse *)response {
    if ([response httpStatusCode] == 201) {
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


//struct AddParticipantsTemplate : RequestTemplate {
//    var scheme: String
//    var host: String
//    var port: Int
//    var pathComponents: [String] { return ["apispaces", apiSpaceId, "conversations", conversationId, "participants"] }
//    let query: [String : String]? = nil
//
//    let httpMethod: HTTPMethod = .post
//    var httpHeaders: Set<HTTPHeader>? { return [.contentType(.JSON), .authorization(token)] }
//    var httpBody: Data? { return try? JSONEncoder.default().encode(participants) }
//
//    var apiSpaceId: String
//    var conversationId: String
//    var token: String
//    var participants: [ConversationParticipant]
//
//    static func result(from data: Data, urlResponse: URLResponse) -> Result<Bool, TemplateResultError> {
//        switch urlResponse.httpStatusCode {
//        case 201?: return .success(true)
//        case 400?: return .failure(.validationError)
//        case 404?: return .failure(.notFound)
//        default: return .failure(.unexpectedStatusCode)
//        }
//    }
//}
