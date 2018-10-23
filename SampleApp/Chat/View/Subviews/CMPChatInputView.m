//
//  CMPChatInputView.m
//  SampleApp
//
//  Created by Dominik Kowalski on 16/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPChatInputView.h"

@implementation CMPChatInputView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.inputTextView = [[CMPPlaceholderTextView alloc] init];
        self.sendButton = [UIButton new];
        self.uploadButton = [UIButton new];
        
        [self configure];
    }
    
    return self;
}

- (void)configure {
    [self customize];
    [self layout];
    [self constrain];
}

- (void)customize {
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowRadius = 4.0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.3;
    self.backgroundColor = UIColor.grayColor;

    self.inputTextView.backgroundColor = UIColor.clearColor;
    self.inputTextView.layer.borderWidth = 1.0;
    self.inputTextView.layer.borderColor = UIColor.whiteColor.CGColor;
    self.inputTextView.layer.masksToBounds = YES;
    self.inputTextView.layer.cornerRadius = 4.0;
    self.inputTextView.clipsToBounds = YES;
    self.inputTextView.scrollEnabled = NO;
    self.inputTextView.inputAccessoryView = nil;
    [self.inputTextView setPlaceholderWithText:@"New message..."];
    self.inputTextView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.sendButton.enabled = NO;
    [self.sendButton setTitle:@"Send" forState:0];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.sendButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.sendButton setTitleColor:UIColor.redColor forState:UIControlStateDisabled];
    [self.sendButton addTarget:self action:@selector(sendTapped) forControlEvents:UIControlEventTouchUpInside];
    self.sendButton.translatesAutoresizingMaskIntoConstraints = NO;

    self.uploadButton.enabled = YES;
    [self.uploadButton setImage:[UIImage imageNamed:@"photo"] forState:0];
    [self.uploadButton addTarget:self action:@selector(uploadTapped) forControlEvents:UIControlEventTouchUpInside];
    self.uploadButton.translatesAutoresizingMaskIntoConstraints = NO;

}

- (void)layout {
    [self addSubview:self.inputTextView];
    [self addSubview:self.sendButton];
    [self addSubview:self.uploadButton];
}

- (void)constrain {
    NSLayoutConstraint *textViewHeight = [self.inputTextView.heightAnchor constraintGreaterThanOrEqualToConstant:40];
    NSLayoutConstraint *textViewBottom = [self.inputTextView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8];
    NSLayoutConstraint *textViewTop = [self.inputTextView.topAnchor constraintEqualToAnchor:self.topAnchor constant:8];
    
    [NSLayoutConstraint activateConstraints:@[textViewHeight, textViewBottom, textViewTop]];
    
    NSLayoutConstraint *sendTrailing = [self.sendButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8];
    NSLayoutConstraint *sendCenterY = [self.sendButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];
    NSLayoutConstraint *sendLeading = [self.sendButton.leadingAnchor constraintEqualToAnchor:self.inputTextView.trailingAnchor constant:8];
    NSLayoutConstraint *sendWidth = [self.sendButton.widthAnchor constraintGreaterThanOrEqualToConstant:46];
    
    [NSLayoutConstraint activateConstraints:@[sendTrailing, sendWidth, sendCenterY, sendLeading]];
    
    NSLayoutConstraint *uploadTrailing = [self.uploadButton.trailingAnchor constraintEqualToAnchor:self.inputTextView.leadingAnchor constant:-8];
    NSLayoutConstraint *uploadCenterY = [self.uploadButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];
    NSLayoutConstraint *uploadLeading = [self.uploadButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8];
    NSLayoutConstraint *uploadWidth = [self.uploadButton.widthAnchor constraintEqualToConstant:24];
    
    [NSLayoutConstraint activateConstraints:@[uploadTrailing, uploadCenterY, uploadLeading, uploadWidth]];
}

- (void)sendTapped {
    if (self.didTapSendButton) {
        self.didTapSendButton();
    }
}

- (void)uploadTapped {
    if (self.didTapUploadButton) {
        self.didTapUploadButton();
    }
}

@end
