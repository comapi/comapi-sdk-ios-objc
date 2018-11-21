//
//  CMPConversationsViewModel.m
//  SampleApp
//
//  Created by Dominik Kowalski on 12/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPConversationsViewModel.h"

@implementation CMPConversationsViewModel

- (instancetype)initWithClient:(CMPComapiClient *)client profile:(CMPProfile *)profile {
    self = [super init];
    
    if (self) {
        self.client = client;
        self.profile = profile;
    }
    
    return self;
}

- (void)getConversationsWithCompletion:(void (^)(NSError * _Nullable))completion {
    [self.client.services.messaging getConversationsWithScope:nil profileID:self.profile.id completion:^(CMPResult<NSArray<CMPConversation *> *> * result) {
        if (result.error) {
            completion(result.error);
        } else {
            self.conversations = [NSMutableArray arrayWithArray:result.object];
            completion(nil);
        }
    }];
}

@end
