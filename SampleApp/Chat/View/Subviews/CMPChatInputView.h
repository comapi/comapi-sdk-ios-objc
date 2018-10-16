//
//  CMPChatInputView.h
//  SampleApp
//
//  Created by Dominik Kowalski on 16/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseView.h"
#import "CMPPlaceholderTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPChatInputView : CMPBaseView <CMPViewConfiguring>

@property (nonatomic, strong) CMPPlaceholderTextView *inputTextView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *uploadButton;

@property (nonatomic, strong) void(^didTapSendButton)(void);
@property (nonatomic, strong) void(^didTapUploadButton)(void);

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
