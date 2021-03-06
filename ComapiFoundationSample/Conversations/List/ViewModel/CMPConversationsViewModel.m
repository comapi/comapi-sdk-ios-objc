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

#import "CMPConversationsViewModel.h"

#import <UserNotifications/UserNotifications.h>

@implementation CMPConversationsViewModel

- (instancetype)initWithClient:(CMPComapiClient *)client profile:(CMPProfile *)profile {
    self = [super init];
    
    if (self) {
        self.client = client;
        self.profile = profile;
        
        [self.client addEventDelegate:self];
    }
    
    return self;
}

- (void)getConversationsWithCompletion:(void (^)(NSError * _Nullable))completion {
    [self.client.services.messaging getConversationsWithProfileID:self.profile.id isPublic:NO completion:^(CMPResult<NSArray<CMPConversation *> *> * result) {
        if (result.error) {
            completion(result.error);
        } else {
            self.conversations = [NSMutableArray arrayWithArray:result.object];
            completion(nil);
        }
    }];
}

- (void)registerForRemoteNotificationsWithCompletion:(void (^)(BOOL, NSError * _Nonnull))completion {
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        completion(granted, error);
    }];
}

- (void)client:(nonnull CMPComapiClient *)client didReceiveEvent:(nonnull CMPEvent *)event {
    if (event.type == CMPEventTypeConversationParticipantAdded) {
        CMPConversationEventParticipantAdded *e = (CMPConversationEventParticipantAdded *)event;
        for (CMPConversation *c in _conversations) {
            if ([c.id isEqualToString:e.conversationID]) {
                return;
            }
        }
        __weak typeof(self) weakSelf = self;
        [self.client.services.messaging getConversationWithConversationID:e.conversationID completion:^(CMPResult<CMPConversation *> * _Nonnull result) {
            [weakSelf.conversations addObject:result.object];
            if (weakSelf.shouldReload) {
                weakSelf.shouldReload();
            }
        }];
    } else if (event.type == CMPEventTypeConversationUpdate) {
        CMPConversationEventUpdate *e = (CMPConversationEventUpdate *)event;
        for (CMPConversation *c in _conversations) {
            if ([c.id isEqualToString:e.conversationID]) {
                c.isPublic = e.payload.isPublic;
                c.name = e.payload.name;
                c.roles = e.payload.roles;
                c.conversationDescription = e.payload.eventDescription;
                if (_shouldReload) {
                    _shouldReload();
                }
            }
        }
    } else if (event.type == CMPEventTypeConversationDelete) {
        CMPConversationEventDelete *e = (CMPConversationEventDelete *)event;
        for (int i = 0; i < _conversations.count; i++) {
            if ([_conversations[i].id isEqualToString:e.conversationID]) {
                [_conversations removeObjectAtIndex:i];
                if (_shouldReload) {
                    _shouldReload();
                }
            }
        }
    }  
}

@end
