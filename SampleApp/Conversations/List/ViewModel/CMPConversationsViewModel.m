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
    [self.client.services.messaging getConversationsWithScope:nil profileID:self.profile.id completion:^(NSArray<CMPConversation *> * _Nullable conversations, NSError * _Nullable error) {
        if (error) {
            completion(error);
        } else {
            self.conversations = [NSMutableArray arrayWithArray:conversations];
            completion(nil);
        }
    }];
}

@end
