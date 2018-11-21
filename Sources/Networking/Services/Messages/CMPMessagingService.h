//
//  CMPMessagingService.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseService.h"
#import "CMPEvent.h"
#import "CMPConversationParticipant.h"
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

- (void)queryEventsWithConversationID:(NSString *)conversationID limit:(NSUInteger)limit from:(NSUInteger)from completion:(void(^)(CMPResult<NSArray<CMPEvent *> *> *))completion;

#pragma mark - ConversationParticipants

- (void)getParticipantsWithConversationID:(NSString *)conversationID completion:(void(^)(CMPResult<NSArray<CMPConversationParticipant *> *> *))completion;
- (void)addParticipantsWithConversationID:(NSString *)conversationID participants:(NSArray<CMPConversationParticipant *> *)participants completion:(void(^)(CMPResult<NSNumber *> *))completion;
- (void)removeParticipantsWithConversationID:(NSString *)conversationID participants:(NSArray<CMPConversationParticipant *> *)participants completion:(void(^)(CMPResult<NSNumber *> *))completion;

#pragma mark - Conversation

- (void)getConversationWithConversationID:(NSString *)conversationID completion:(void(^)(CMPResult<CMPConversation *> *))completion;
- (void)getConversationsWithScope:(nullable NSString *)scope profileID:(NSString *)profileID completion:(void(^)(CMPResult<NSArray<CMPConversation *> *> * _Nullable))completion;
- (void)addConversationWithConversation:(CMPNewConversation *)conversation completion:(void(^)(CMPResult<CMPConversation *> *))completion;
- (void)updateConversationWithConversationID:(NSString *)conversationID conversation:(CMPConversationUpdate *)conversation eTag:(nullable NSString *)eTag completion:(void(^)(CMPResult<CMPConversation *> *))completion;
- (void)deleteConversationWithConversationID:(NSString *)conversationID eTag:(nullable NSString *)eTag completion:(void(^)(CMPResult<NSNumber *> *))completion;


#pragma mark - Messages

- (void)getMessagesWithConversationID:(NSString *)conversationID limit:(NSUInteger)limit from:(NSUInteger)from completion:(void(^)(CMPResult<CMPGetMessagesResult *> *))completion;
- (void)sendMessage:(CMPSendableMessage *)message toConversationWithID:(NSString *)conversationID completion:(void(^)(CMPResult<CMPSendMessagesResult *> *))completion;

#pragma mark - Status

- (void)updateStatusForMessagesWithIDs:(NSArray<NSString *> *)messageIDs status:(NSString *)status conversationID:(NSString *)conversationID timestamp:(NSDate *)timestamp completion:(void (^)(CMPResult<NSNumber *> *))completion;

#pragma mark - Content

- (void)uploadContent:(CMPContentData *)content folder:(nullable NSString *)folder completion:(void(^)(CMPResult<CMPContentUploadResult *> *))completion;
- (void)uploadUrl:(NSURL *)url filename:(NSString *)filename type:(NSString *)type folder:(nullable NSString *)folder completion:(void(^)(CMPResult<CMPContentUploadResult *> *))completion;
- (void)uploadData:(NSData *)data filename:(NSString *)filename type:(NSString *)type folder:(nullable NSString *)folder completion:(void(^)(CMPResult<CMPContentUploadResult *> *))completion;


@end

NS_SWIFT_NAME(MessagingService)
@interface CMPMessagingService : CMPBaseService <CMPMessagingServiceable>

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
