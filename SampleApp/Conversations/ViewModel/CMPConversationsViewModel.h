//
//  CMPConversationsViewModel.h
//  SampleApp
//
//  Created by Dominik Kowalski on 12/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPComapiClient.h"
#import "CMPConversation.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPConversationsViewModel : NSObject

@property (nonatomic, strong) CMPComapiClient *client;
@property (nonatomic, strong) CMPProfile *profile;
@property (nonatomic, strong) NSMutableArray<CMPConversation *> *conversations;

- (instancetype)initWithClient:(CMPComapiClient *)client profile:(CMPProfile *)profile;
- (void)getConversationsWithCompletion:(void(^)(NSError * _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
