//
//  CMPAddParticipantsViewModel.h
//  SampleApp
//
//  Created by Dominik Kowalski on 17/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPComapiClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPAddParticipantsViewModel : NSObject

@property (nonatomic, strong) CMPComapiClient *client;
@property (nonatomic, strong) CMPConversationParticipant *participant;
@property (nonatomic, strong) NSString *conversationID;

- (instancetype)initWithClient:(CMPComapiClient *)client conversationID:(NSString *)conversationID;

- (BOOL)validate;
- (void)updateID:(NSString *)ID;
- (void)getProfileForID:(NSString *)ID completion:(void(^)(BOOL, NSError * _Nullable))completion;
- (void)addParticipantWithCompletion:(void(^)(BOOL, NSError * _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
