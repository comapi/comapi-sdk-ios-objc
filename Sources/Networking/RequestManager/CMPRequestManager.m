//
//  CMPRequestManager.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 17/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestManager.h"

@interface CMPRequestManager ()

@property (nonatomic, strong) NSMutableArray<CMPPendingOperation>* pendingOperations;
@property (nonatomic) CMPTokenState tokenState;
@property (nonatomic, strong, nullable) NSString *token;

@end

@implementation CMPRequestManager

- (instancetype)initWithRequestPerformer:(id<CMPRequestPerforming>)requestPerformer {
    self = [super init];
    
    if (self) {
        self.requestPerformer = requestPerformer;
        self.pendingOperations = [NSMutableArray array];
        self.tokenState = CMPTokenStateMissing;
    }
    
    return self;
}

- (void)performUsingTemplateBuilder:(id<CMPHTTPRequestTemplate>(^)(NSString *))templateBuilder completion:(void(^)(CMPRequestTemplateResult *))completion {
    __weak typeof(self) weakSelf = self;
    switch (self.tokenState) {
        case CMPTokenStateMissing: {
            [self.pendingOperations addObject: [^{ [weakSelf performUsingTemplateBuilder:templateBuilder completion:completion]; } copy]];
            [self requestToken];
            break;
        }
        case CMPTokenStateAwaiting: {
            [self.pendingOperations addObject: [^{ [weakSelf performUsingTemplateBuilder:templateBuilder completion:completion]; } copy]];
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
    NSMutableArray<CMPPendingOperation> *operations = [self.pendingOperations copy];
    [self.pendingOperations removeAllObjects];
    [operations enumerateObjectsUsingBlock:^(CMPPendingOperation _Nonnull operation, NSUInteger idx, BOOL * _Nonnull stop) {
        operation();
    }];
}

- (void)requestToken {
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


