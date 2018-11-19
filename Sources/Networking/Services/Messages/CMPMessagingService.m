//
//  CMPMessagingService.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMessagingService.h"
#import "CMPEventQueryTemplate.h"
#import "CMPGetParticipantsTemplate.h"
#import "CMPAddParticipantsTemplate.h"
#import "CMPRemoveParticipantsTemplate.h"
#import "CMPGetConversationTemplate.h"
#import "CMPGetConversationsTemplate.h"
#import "CMPAddConversationTemplate.h"
#import "CMPUpdateConversationTemplate.h"
#import "CMPDeleteConversationTemplate.h"
#import "CMPGetMessagesTemplate.h"
#import "CMPSendMessagesTemplate.h"
#import "CMPSendStatusUpdateTemplate.h"
#import "CMPContentUploadTemplate.h"

@implementation CMPMessagingService

#pragma mark - Events

- (void)queryEventsWithConversationID:(NSString *)conversationID limit:(NSUInteger)limit from:(NSUInteger)from completion:(void (^)(NSArray<CMPEvent *> * _Nonnull, NSError * _Nullable))completion {
    CMPEventQueryTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPEventQueryTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID from:from limit:limit token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPRequestTemplateResult * _Nonnull result) {
        if (result.error) {
            completion(@[], result.error);
        } else {
            completion(result.object, nil);
        }
    }];
}

#pragma mark - ConversationParticipants

- (void)getParticipantsWithConversationID:(NSString *)conversationID completion:(void(^)(NSArray<CMPConversationParticipant *> * _Nonnull, NSError * _Nullable))completion {
    CMPGetParticipantsTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPGetParticipantsTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPRequestTemplateResult * _Nonnull result) {
        if (result.error) {
            completion(@[], result.error);
        } else {
            completion(result.object, nil);
        }
    }];
}

- (void)addParticipantsWithConversationID:(nonnull NSString *)conversationID participants:(nonnull NSArray<CMPConversationParticipant *> *)participants completion:(nonnull void (^)(BOOL, NSError * _Nullable))completion {
    CMPAddParticipantsTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPAddParticipantsTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID participants:participants token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPRequestTemplateResult * _Nonnull result) {
        if (result.error) {
            completion(NO, result.error);
        } else {
            completion(YES, nil);
        }
    }];
}

- (void)removeParticipantsWithConversationID:(nonnull NSString *)conversationID participants:(nonnull NSArray<CMPConversationParticipant *> *)participants completion:(nonnull void (^)(BOOL, NSError * _Nullable))completion {
    CMPRemoveParticipantsTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPRemoveParticipantsTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID participants:participants token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPRequestTemplateResult * _Nonnull result) {
        if (result.error) {
            completion(NO, result.error);
        } else {
            completion(YES, nil);
        }
    }];
}

#pragma mark - Conversation

- (void)addConversationWithConversation:(nonnull CMPNewConversation *)conversation completion:(nonnull void (^)(CMPConversation * _Nullable, NSError * _Nullable))completion {
    CMPAddConversationTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPAddConversationTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversation:conversation token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPRequestTemplateResult * _Nonnull result) {
        if (result.error) {
            completion(nil, result.error);
        } else {
            completion(result.object, nil);
        }
    }];
}


- (void)deleteConversationWithConversationID:(nonnull NSString *)conversationID eTag:(nullable NSString *)eTag completion:(nonnull void (^)(BOOL, NSError * _Nullable))completion {
    CMPDeleteConversationTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPDeleteConversationTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID eTag:eTag token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPRequestTemplateResult * _Nonnull result) {
        if (result.error) {
            completion(NO, result.error);
        } else {
            completion(YES, nil);
        }
    }];
}


- (void)getConversationWithConversationID:(nonnull NSString *)conversationID completion:(nonnull void (^)(CMPConversation * _Nullable, NSError * _Nullable))completion {
    CMPGetConversationTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPGetConversationTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPRequestTemplateResult * _Nonnull result) {
        if (result.error) {
            completion(nil, result.error);
        } else {
            completion(result.object, nil);
        }
    }];
}


- (void)getConversationsWithScope:(nullable NSString *)scope profileID:(NSString *)profileID completion:(void(^)(NSArray<CMPConversation *> * _Nullable, NSError * _Nullable))completion {
    CMPGetConversationsTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPGetConversationsTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID profileID:profileID scope:scope token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPRequestTemplateResult * _Nonnull result) {
        if (result.error) {
            completion(nil, result.error);
        } else {
            completion(result.object, nil);
        }
    }];
}


- (void)updateConversationWithConversationID:(nonnull NSString *)conversationID conversation:(nonnull CMPConversationUpdate *)conversation eTag:(nullable NSString *)eTag completion:(nonnull void (^)(CMPConversation * _Nullable, NSError * _Nullable))completion {
    CMPUpdateConversationTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPUpdateConversationTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID eTag:eTag conversation:conversation token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPRequestTemplateResult * _Nonnull result) {
        if (result.error) {
            completion(nil, result.error);
        } else {
            completion(result.object, nil);
        }
    }];
}

#pragma mark - Messages

- (void)getMessagesWithConversationID:(NSString *)conversationID limit:(NSUInteger)limit from:(NSUInteger)from completion:(void (^)(CMPGetMessagesResult * _Nullable, NSError * _Nullable))completion {
    CMPGetMessagesTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPGetMessagesTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID from:from limit:limit token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPRequestTemplateResult * _Nonnull result) {
        if (result.error) {
            completion(nil, result.error);
        } else {
            CMPGetMessagesResult *object = (CMPGetMessagesResult *)result.object;
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"context.sentOn" ascending:YES];
            object.messages = [object.messages sortedArrayUsingDescriptors:@[sortDescriptor]];
            completion(result.object, nil);
        }
    }];
}

- (void)sendMessage:(CMPSendableMessage *)message toConversationWithID:(NSString *)conversationID completion:(void (^)(CMPSendMessagesResult * _Nullable, NSError * _Nullable))completion {
    CMPSendMessagesTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPSendMessagesTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID message:message token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPRequestTemplateResult * _Nonnull result) {
        if (result.error) {
            completion(nil, result.error);
        } else {
            completion(result.object, nil);
        }
    }];
}

#pragma mark - Status

- (void)updateStatusForMessagesWithIDs:(NSArray<NSString *> *)messageIDs status:(NSString *)status conversationID:(NSString *)conversationID timestamp:(NSDate *)timestamp completion:(void (^)(BOOL, NSError * _Nullable))completion {
    CMPSendStatusUpdateTemplate *(^builder)(NSString *) = ^(NSString *token) {
        CMPMessageStatusUpdate *statusUpdate = [[CMPMessageStatusUpdate alloc] initWithStatus:status timestamp:timestamp messageIDs:messageIDs];
        return [[CMPSendStatusUpdateTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID token:token statusUpdates:@[statusUpdate]];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPRequestTemplateResult * _Nonnull result) {
        if (result.error) {
            completion(NO, result.error);
        } else {
            completion(YES, nil);
        }
    }];
}

#pragma mark - Content

- (void)uploadContent:(CMPContentData *)content folder:(NSString *)folder completion:(void (^)(CMPContentUploadResult * _Nullable, NSError * _Nullable))completion {
    CMPContentUploadTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPContentUploadTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID content:content folder:folder token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPRequestTemplateResult * _Nonnull result) {
        if (result.error) {
            completion(nil, result.error);
        } else {
            completion(result.object, nil);
        }
    }];
}

- (void)uploadUrl:(NSURL *)url filename:(NSString *)filename type:(NSString *)type folder:(NSString *)folder completion:(void (^)(CMPContentUploadResult * _Nullable, NSError * _Nullable))completion {
    CMPContentData *content = [[CMPContentData alloc] initWithUrl:url type:type name:filename];
    [self uploadContent:content folder:folder completion:completion];
}

- (void)uploadData:(NSData *)data filename:(NSString *)filename type:(NSString *)type folder:(NSString *)folder completion:(void (^)(CMPContentUploadResult * _Nullable, NSError * _Nullable))completion {
    CMPContentData *content = [[CMPContentData alloc] initWithData:data type:type name:filename];
    [self uploadContent:content folder:folder completion:completion];
}

@end
