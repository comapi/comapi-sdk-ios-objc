//
//  CMPRequestManager.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 17/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestManager.h"

@interface CMPRequestManager ()

@property (atomic, copy) NSMutableArray<CMPPendingOperation>* pendingOperations;
@property (atomic) CMPTokenState tokenState;
@property (atomic, nullable) NSString *token;

@end

@implementation CMPRequestManager

- (instancetype)initWithRequestPerformer:(CMPRequestPerformer *)requestPerformer {
    self = [super init];
    
    if (self) {
        self.requestPerformer = requestPerformer;
    }
    
    return self;
}

//internal func performUsing<T: RequestTemplate>(templateBuilder: @escaping (_ token: String) -> T,
//                                               completion: @escaping RequestTemplatePerformingCompletion<T.ResultType>) {
//    switch self.tokenState {
//    case .missing: // add to pending
//        self.pendingOperations.append { self.performUsing(templateBuilder: templateBuilder, completion: completion) }
//        self.requestToken()
//
//    case .awaiting: // add to pending
//        self.pendingOperations.append { self.performUsing(templateBuilder: templateBuilder, completion: completion) }
//
//    case .failed: // respond with missing token error immediatelly
//        completion(.failure(.requestCreationFailed))
//
//    case .ready(let token): // execute request
//
//        let template = templateBuilder(token)
//
//        self.requestTemplatePerformer.performFromTemplate(template) { status in
//
//            switch status {
//            case .success(_):
//                completion(status)
//            case .failure(let reason):
//                switch reason {
//                case .unauthorized:
//                    self.requestToken()
//                    self.performUsing(templateBuilder: templateBuilder, completion: completion)
//                case .requestCreationFailed:
//                    completion(.failure(.requestCreationFailed))
//                case .responseParsingFailed(let error):
//                    completion(.failure(.responseParsingFailed(error)))
//                case .connectionFailed(let error):
//                    completion(.failure(.connectionFailed(error)))
//                }
//            }
//        }
//    }
//}

- (void)performUsingTemplateBuilder:(id<CMPHTTPRequestTemplate>(^)(NSString *))templateBuilder completion:(void(^)(CMPRequestTemplateResult *))completion {
    __weak CMPRequestManager *weakSelf = self;
    switch (self.tokenState) {
        case CMPTokenStateMissing: {
            [self.pendingOperations addObject: ^{ [weakSelf performUsingTemplateBuilder:templateBuilder completion:completion]; }];
            [self requestToken];
            break;
        }
        case CMPTokenStateAwaiting: {
            [self.pendingOperations addObject: ^{ [weakSelf performUsingTemplateBuilder:templateBuilder completion:completion]; }];
            break;
        }
        case CMPTokenStateReady: {
            id<CMPHTTPRequestTemplate> template = templateBuilder(self.token);
            [template performWithRequestPerformer:self.requestPerformer result:^(CMPRequestTemplateResult * _Nonnull result) {
                completion(result);
            }];
            break;
        }
        case CMPTokenStateFailed: {
            NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorRequestCreationFailed underlyingError:nil];
            completion([[CMPRequestTemplateResult alloc] initWithObject:nil error:error]);
            break;
        }
    }
}

- (void)runAllPendingOperations {
    NSArray<CMPPendingOperation> *operations = [self.pendingOperations copy];
    [self.pendingOperations removeAllObjects];
    [operations enumerateObjectsUsingBlock:^(CMPPendingOperation _Nonnull operation, NSUInteger idx, BOOL * _Nonnull stop) {
        operation();
    }];
}

- (void)requestToken {
    self.token = nil;
    if (self.tokenState == CMPTokenStateAwaiting) {
        return;
    }
    
    if (self.delegate != nil) {
        [self.delegate requestManagerNeedsToken:self];
    } else {
        self.tokenState = CMPTokenStateFailed;
        [self runAllPendingOperations];
        self.tokenState = CMPTokenStateAwaiting;
    }
}

- (void)updateToken:(NSString *)token {
    self.token = token;
    self.tokenState = CMPTokenStateReady;
    [self runAllPendingOperations];
}

- (void)tokenUpdateFailed {
    self.tokenState = CMPTokenStateFailed;
    [self runAllPendingOperations];
    self.tokenState = CMPTokenStateMissing;
}

@end


