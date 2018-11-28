//
// The MIT License (MIT)
// Copyright (c) 2017 Comapi (trading name of Dynmark International Limited)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
    
    self.participant.role = CMPRoleParticipant;
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
