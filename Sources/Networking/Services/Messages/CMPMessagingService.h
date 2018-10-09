//
//  CMPMessagingService.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseService.h"
#import "CMPConversationParticipant.h"
#import "CMPEventContainer.h"
#import "CMPConversation.h"
#import "CMPNewConversation.h"
#import "CMPConversationUpdate.h"
#import "CMPGetMessagesResult.h"
#import "CMPSendMessagesResult.h"
#import "CMPSendableMessage.h"
#import "CMPContentData.h"
#import "CMPContentUploadResult.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MessagingServiceable)
@protocol CMPMessagingServiceable <NSObject>

#pragma mark - Events

- (void)queryEventsWithConversationID:(NSString *)conversationID limit:(NSUInteger)limit from:(NSUInteger)from completion:(void(^)(NSArray<CMPEventContainer *> *, NSError * _Nullable))completion;

#pragma mark - ConversationParticipants

- (void)getParticipantsWithConversationID:(NSString *)conversationID completion:(void(^)(BOOL, NSError * _Nullable))completion;
- (void)addParticipantsWithConversationID:(NSString *)conversationID participants:(NSArray<CMPConversationParticipant *> *)participants completion:(void(^)(BOOL, NSError * _Nullable))completion;
- (void)removeParticipantsWithConversationID:(NSString *)conversationID participants:(NSArray<CMPConversationParticipant *> *)participants completion:(void(^)(BOOL, NSError * _Nullable))completion;

#pragma mark - Conversation

- (void)getConversationWithConversationID:(NSString *)conversationID completion:(void(^)(CMPConversation * _Nullable, NSError * _Nullable))completion;
- (void)getConversationsWithScope:(NSString *)scope profileID:(NSString *)profileID completion:(void(^)(NSArray<CMPConversation *> * _Nullable, NSError * _Nullable))completion;
- (void)addConversationWithConversation:(CMPNewConversation *)conversation completion:(void(^)(CMPConversation * _Nullable, NSError * _Nullable))completion;
- (void)updateConversationWithConversationID:(NSString *)conversationID conversation:(CMPConversationUpdate *)conversation eTag:(nullable NSString *)eTag completion:(void(^)(CMPConversation * _Nullable, NSError * _Nullable))completion;
- (void)deleteConversationWithConversationID:(NSString *)conversationID eTag:(nullable NSString *)eTag completion:(void(^)(BOOL, NSError * _Nullable))completion;


#pragma mark - Messages

- (void)getMessagesWithConversationID:(NSString *)conversationID limit:(NSUInteger)limit from:(NSUInteger)from completion:(void(^)(CMPGetMessagesResult * _Nullable, NSError * _Nullable))completion;
- (void)sendMessage:(CMPSendableMessage *)message toConversationWithID:(NSString *)conversationID completion:(void(^)(CMPSendMessagesResult * _Nullable, NSError * _Nullable))completion;

#pragma mark - Status

- (void)updateStatusForMessagesWithIDs:(NSArray<NSString *> *)messageIDs status:(NSString *)status conversationID:(NSString *)conversationID timestamp:(NSDate *)timestamp completion:(void (^)(BOOL, NSError * _Nullable))completion;

#pragma mark - Content

- (void)uploadContent:(CMPContentData *)content folder:(nullable NSString *)folder completion:(void(^)(CMPContentUploadResult * _Nullable, NSError * _Nullable))completion;
- (void)uploadUrl:(NSURL *)url filename:(NSString *)filename type:(NSString *)type folder:(nullable NSString *)folder completion:(void(^)(CMPContentUploadResult * _Nullable, NSError * _Nullable))completion;
- (void)uploadData:(NSData *)data filename:(NSString *)filename type:(NSString *)type folder:(nullable NSString *)folder completion:(void(^)(CMPContentUploadResult * _Nullable, NSError * _Nullable))completion;


@end

NS_SWIFT_NAME(MessagingService)
@interface CMPMessagingService : CMPBaseService <CMPMessagingServiceable>

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
