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

@property (nonatomic, copy) NSMutableArray<CMPPendingOperation>* pendingOperations;
@property (nonatomic) CMPTokenState tokenState;
@property (nonatomic, nullable) NSString *token;

@end

@implementation CMPRequestManager

//- (void)performUsingTemplate:(id<CMPHTTPRequestTemplate>)template completion:() {
    
//}

- (void)runAllPendingOperations {
    NSArray<CMPPendingOperation> *operations = [self.pendingOperations copy];
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


