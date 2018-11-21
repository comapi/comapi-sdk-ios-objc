//
//  CMPCreateConversationViewModel.m
//  SampleApp
//
//  Created by Dominik Kowalski on 15/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPCreateConversationViewModel.h"

@implementation CMPCreateConversationViewModel

- (instancetype)initWithClient:(CMPComapiClient *)client {
    self = [super init];
    
    if (self) {
        self.conversation = [[CMPNewConversation alloc] init];
        self.client = client;
    }
    
    return self;
}

- (BOOL)validate {
    return self.conversation.conversationDescription != nil && self.conversation.name != nil;
}

- (CMPRoles *)createRoles {
    CMPRoleAttributes *ownerAttributes = [[CMPRoleAttributes alloc] initWithCanSend:YES canAddParticipants:YES canRemoveParticipants:YES];
    CMPRoleAttributes *participantAttributes = [[CMPRoleAttributes alloc] initWithCanSend:YES canAddParticipants:NO canRemoveParticipants:NO];
    CMPRoles *roles = [[CMPRoles alloc] initWithOwnerAttributes:ownerAttributes participantAttributes:participantAttributes];
    
    return roles;
}

- (void)getProfilesWithCompletion:(void (^)(NSArray<CMPProfile *> * _Nullable, NSError * _Nullable))completion {
    NSString *profileID = self.client.profileID;
    if (profileID) {
        __weak typeof(self) weakSelf = self;
        [self.client.services.profile queryProfilesWithQueryElements:@[] completion:^(CMPResult<NSArray<CMPProfile *> *> * result) {
            if (result.error) {
                completion(nil, result.error);
            } else {
                weakSelf.profiles = result.object;
                completion(weakSelf.profiles, nil);
            }
        }];
    }
}

- (void)getConversationWithID:(NSString *)ID completion:(void (^)(CMPConversation * _Nullable, NSError * _Nullable))completion {
    [self.client.services.messaging getConversationWithConversationID:ID completion:^(CMPResult<CMPConversation *> *result) {
        if (result.error) {
            completion(nil, result.error);
        } else {
            completion(result.object, nil);
        }
    }];
}

- (void)createConversation:(BOOL)isPublic completion:(void (^)(BOOL exists, CMPConversation * _Nullable conversation, NSError * _Nullable error))completion {
    NSString *profileID = self.client.profileID;
    if ([self validate] && profileID != nil) {
        CMPConversationParticipant *me = [[CMPConversationParticipant alloc] initWithID:profileID role:@"owner"];
        NSString *id = [@[self.conversation.name, profileID] componentsJoinedByString:@"_"];
        __weak typeof(self) weakSelf = self;
        [self getConversationWithID:id completion:^(CMPConversation * _Nullable conversation, NSError * _Nullable error) {
            if (conversation) {
                completion(YES, conversation, nil);
            } else {
                CMPRoles *roles = [self createRoles];
                weakSelf.conversation.participants = @[me];
                weakSelf.conversation.isPublic = [NSNumber numberWithBool:isPublic];
                weakSelf.conversation.roles = roles;
                weakSelf.conversation.id = id;
                
                [weakSelf.client.services.messaging addConversationWithConversation:weakSelf.conversation completion:^(CMPResult<CMPConversation *> *result) {
                    if (result.error) {
                        completion(NO, nil, result.error);
                    } else {
                        completion(NO, result.object, nil);
                    }
                }];
            }
        }];
    }
}

@end
