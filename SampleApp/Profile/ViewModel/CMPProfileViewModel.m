//
//  CMPProfileViewModel.m
//  SampleApp
//
//  Created by Dominik Kowalski on 12/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPProfileViewModel.h"

@implementation CMPProfileViewModel

- (instancetype)initWithClient:(CMPComapiClient *)client {
    self = [super init];
    
    if (self) {
        self.client = client;
        self.profiles = [NSMutableArray new];
    }
    
    return self;
}

- (void)getProfilesWithCompletion:(void(^)(NSError * _Nullable))completion {
    __weak typeof(self) weakSelf = self;
    [self.client.services.profile queryProfilesWithQueryElements:@[] completion:^(CMPRequestTemplateResult * _Nonnull result) {
        if (result.error) {
            [[CMPLogger shared] verbose:@[result.error]];
            completion(result.error);
        } else {
            weakSelf.profiles = result.object;
            completion(nil);
        }
    }];
}

@end
