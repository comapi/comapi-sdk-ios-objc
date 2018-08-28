//
//  CMPRequestManager.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 17/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestManager.h"
#import "CMPRequestTemplate.h"

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

- (void)performUsingTemplate:(id<CMPHTTPRequestTemplate>)template completion:(void(^)(CMPRequestTemplateResult *))completion {
    __weak CMPRequestManager *weakSelf = self;
    switch (self.tokenState) {
        case CMPTokenStateMissing: {
            [self.pendingOperations addObject: ^{ [weakSelf performUsingTemplate:template completion:completion]; }];
            [self requestToken];
            break;
        }
        case CMPTokenStateAwaiting: {
            [self.pendingOperations addObject: ^{ [weakSelf performUsingTemplate:template completion:completion]; }];
            break;
        }
        case CMPTokenStateReady: {
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


