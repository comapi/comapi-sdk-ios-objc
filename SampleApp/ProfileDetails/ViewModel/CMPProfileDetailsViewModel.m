//
//  CMPProfileDetailsViewModel.m
//  SampleApp
//
//  Created by Dominik Kowalski on 19/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPProfileDetailsViewModel.h"

@implementation CMPProfileDetailsViewModel

- (instancetype)initWithClient:(CMPComapiClient *)client profile:(CMPProfile *)profile {
    self = [super init];
    
    if (self) {
        _client = client;
        _profile = profile;
        _email = profile.email != nil ? profile.email : @"";
    }
    
    return self;
}

- (void)updateEmail:(NSString *)email completion:(void (^)(NSError * _Nullable))completion {
    [self.client.services.profile updateProfileForProfileID:self.profile.id attributes:@{@"email" : email} eTag:nil completion:^(CMPProfile * profile, NSError * error) {
        if (error) {
            completion(error);
        } else {
            completion(nil);
        }
    }];
}

@end
