//
//  CMPCreateConversationViewModel.h
//  SampleApp
//
//  Created by Dominik Kowalski on 15/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPComapiClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPCreateConversationViewModel : NSObject

@property (nonatomic, strong) CMPComapiClient *client;
@property (nonatomic, strong) NSArray<CMPProfile *> *profiles;
@property (nonatomic, strong) CMPNewConversation *conversation;

- (instancetype)initWithClient:(CMPComapiClient *)client;

- (BOOL)validate;
- (CMPRoles *)createRoles;
- (void)getProfilesWithCompletion:(void(^)(NSArray<CMPProfile *> * _Nullable, NSError * _Nullable))completion;
- (void)getConversationWithID:(NSString *)ID completion:(void(^)(CMPConversation * _Nullable, NSError * _Nullable))completion;
- (void)createConversation:(BOOL)isPublic completion:(void(^)(BOOL, CMPConversation * _Nullable, NSError * _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
