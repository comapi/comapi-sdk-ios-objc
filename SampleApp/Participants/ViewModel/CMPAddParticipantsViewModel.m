//
//  CMPAddParticipantsViewModel.m
//  SampleApp
//
//  Created by Dominik Kowalski on 17/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAddParticipantsViewModel.h"

@implementation CMPAddParticipantsViewModel

- (instancetype)initWithClient:(CMPComapiClient *)client conversationID:(NSString *)conversationID {
    self = [super init];
    
    if (self) {
        self.client = client;
        self.conversationID = conversationID;
        self.participant = [[CMPConversationParticipant alloc] init];
    }
    
    return self;
}

- (void)updateID:(NSString *)ID {
    self.participant.id = ID;
}

- (BOOL)validate {
    return self.participant.id != nil;
}

- (void)getProfileForID:(NSString *)ID completion:(void (^)(BOOL, NSError * _Nullable))completion {
    [self.client.services.profile getProfileWithProfileID:ID completion:^(CMPResult<CMPProfile *> * result) {
        if (result.error) {
            completion(NO, result.error);
        } else {
            completion(YES, nil);
        }
    }];
}

- (void)addParticipantWithCompletion:(void (^)(BOOL, NSError * _Nullable))completion {
    if (![self validate]) {
        completion(NO, [[NSError alloc] initWithDomain:@"invalid" code:10007 userInfo:@{}]);
        return;
    }
    
    self.participant.role = @"participant";
    __weak typeof(self) weakSelf = self;
    [self getProfileForID:self.participant.id completion:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            completion(success, error);
        } else {
            [weakSelf.client.services.messaging addParticipantsWithConversationID:self.conversationID participants:@[self.participant] completion:^(CMPResult<NSNumber *> *result) {
                if (result.error) {
                    completion([result.object boolValue], error);
                } else {
                    completion([result.object boolValue], nil);
                }
            }];
        }
    }];
}

@end
