//
//  CMPChatView.h
//  SampleApp
//
//  Created by Dominik Kowalski on 15/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseView.h"
#import "CMPChatInputView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPChatView : CMPBaseView <CMPViewConfiguring>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CMPChatInputView *inputMessageView;

@property (nonatomic, copy, nullable) void(^didTapSendButton)(NSString *);
@property (nonatomic, copy, nullable) void(^didTapUploadButton)(void);

@property (nonatomic, strong) NSLayoutConstraint *animatableConstraint;

- (instancetype)init;

- (void)animateOnKeyboardChangeWithNotification:(NSNotification *)notification completion:(void(^_Nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
