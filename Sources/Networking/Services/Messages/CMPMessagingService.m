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

@implementation CMPMessagingService

#pragma mark - Events

- (void)queryEventsWithConversationID:(NSString *)conversationID limit:(NSUInteger)limit from:(NSUInteger)from completion:(void (^)(NSArray<CMPEventContainer *> * _Nonnull, NSError * _Nullable))completion {
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

- (void)getParticipantsWithConversationID:(nonnull NSString *)conversationID completion:(nonnull void (^)(BOOL, NSError * _Nullable))completion {
    CMPGetParticipantsTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPGetParticipantsTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPRequestTemplateResult * _Nonnull result) {
        if (result.error) {
            completion(NO, result.error);
        } else {
            completion(YES, nil);
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


- (void)getConversationsWithScope:(nonnull NSString *)scope profileID:(nonnull NSString *)profileID completion:(nonnull void (^)(NSArray<CMPConversation *> * _Nullable, NSError * _Nullable))completion {
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

@end



//public func getParticipants(forConversationId conversationId: String, completion: @escaping (Result<[ConversationParticipant], NSError>) -> Void){
//
//    let builder = { token in
//        return GetParticipantsTemplate( scheme: self.apiConfiguration.scheme,
//                                       host: self.apiConfiguration.host,
//                                       port: self.apiConfiguration.port,
//                                       apiSpaceId: self.apiSpaceId,
//                                       conversationId: conversationId,
//                                       token: token)
//    }
//
//    self.requestManager.performUsing(templateBuilder: builder) { (result) in
//        switch result {
//        case .success(let value):
//            completion(.success(value.parsedResult))
//        case .failure(let error):
//            completion(.failure(error as NSError))
//        }
//    }
//}
//
//public func addParticipants(forConversationId conversationId: String, participants: [ConversationParticipant], completion: @escaping (Result<Bool, NSError>) -> Void){
//
//    let builder = { token in
//        return AddParticipantsTemplate( scheme: self.apiConfiguration.scheme,
//                                       host: self.apiConfiguration.host,
//                                       port: self.apiConfiguration.port,
//                                       apiSpaceId: self.apiSpaceId,
//                                       conversationId: conversationId,
//                                       token: token,
//                                       participants: participants)
//    }
//
//    self.requestManager.performUsing(templateBuilder: builder) { (result) in
//        switch result {
//        case .success(let value):
//            completion(.success(value.parsedResult))
//        case .failure(let error):
//            completion(.failure(error as NSError))
//        }
//    }
//}
//
//public func removeParticipants(forConversationId conversationId: String, participants: [ConversationParticipant], completion: @escaping (Result<Bool, NSError>) -> Void){
//    let builder = { token in
//        return RemoveParticipantsTemplate( scheme: self.apiConfiguration.scheme,
//                                          host: self.apiConfiguration.host,
//                                          port: self.apiConfiguration.port,
//                                          apiSpaceId: self.apiSpaceId,
//                                          conversationId: conversationId,
//                                          token: token,
//                                          participants: participants)
//    }
//
//    self.requestManager.performUsing(templateBuilder: builder) { (result) in
//        switch result {
//        case .success(let value):
//            completion(.success(value.parsedResult))
//        case .failure(let error):
//            completion(.failure(error as NSError))
//        }
//    }
//}
