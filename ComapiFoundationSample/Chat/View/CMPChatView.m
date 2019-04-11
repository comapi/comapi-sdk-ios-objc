//
// The MIT License (MIT)
// Copyright (c) 2017 Comapi (trading name of Dynmark International Limited)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "CMPChatView.h"
#import "CMPMessagePartCell.h"

@implementation CMPChatView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.tableView = [UITableView new];
        self.inputMessageView = [[CMPChatInputView alloc] init];
        self.attachmentsView = [[CMPAttachmentsView alloc] init];
        self.messageView = [[CMPNewMessageView alloc] init];
        
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
    self.backgroundColor = UIColor.grayColor;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = UIColor.grayColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    [self.tableView registerClass:CMPMessagePartCell.class forCellReuseIdentifier:@"cell"];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    __weak typeof(self) weakSelf = self;
    self.inputMessageView.didTapSendButton = ^{
        if (weakSelf.didTapSendButton) {
            weakSelf.didTapSendButton(weakSelf.inputMessageView.inputTextView.text);
        }
        [weakSelf.inputMessageView.inputTextView clearInput];
    };
    self.inputMessageView.inputTextView.didChangeText = ^(UITextView *textView) {
        [weakSelf adjustTableViewContentInset];
        [weakSelf updateSendButtonState];
    };
    self.inputMessageView.didTapUploadButton = ^{
        if (weakSelf.didTapUploadButton) {
            weakSelf.didTapUploadButton();
        }
    };
    self.inputMessageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.attachmentsView.alpha = 0.0;
    self.attachmentsView.isShown = NO;
    self.attachmentsView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.messageView configureWithText:@"New message!"];
    self.messageView.alpha = 0.0;
    self.messageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageView.didTapView = ^{
        if (weakSelf.didTapNewMessageButton) {
            weakSelf.didTapNewMessageButton();
        }
    };
}

- (void)layout {
    [self addSubview:self.tableView];
    [self addSubview:self.inputMessageView];
    [self addSubview:self.attachmentsView];
    [self addSubview:self.messageView];
}

- (void)constrain {
    NSLayoutConstraint *tableTop;
    
    if (@available(iOS 11.0, *)) {
        tableTop = [self.tableView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor];
        self.animatableConstraint = [self.inputMessageView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor];
    } else {
        tableTop = [self.tableView.topAnchor constraintEqualToAnchor:self.topAnchor];
        self.animatableConstraint = [self.inputMessageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    }
    
    NSLayoutConstraint *inputTrailing = [self.inputMessageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    NSLayoutConstraint *inputLeading = [self.inputMessageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    
    [NSLayoutConstraint activateConstraints:@[inputTrailing, inputLeading, self.animatableConstraint]];
    
    NSLayoutConstraint *avTrailing = [self.attachmentsView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0];
    NSLayoutConstraint *avLeading = [self.attachmentsView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0];
    NSLayoutConstraint *avBottom = [self.attachmentsView.bottomAnchor constraintEqualToAnchor:self.inputMessageView.topAnchor constant:0];
    NSLayoutConstraint *avHeight = [self.attachmentsView.heightAnchor constraintEqualToConstant:64];
    
    [NSLayoutConstraint activateConstraints:@[avLeading, avTrailing, avBottom, avHeight]];
    
    NSLayoutConstraint *tableTrailing = [self.tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    NSLayoutConstraint *tableLeading = [self.tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    NSLayoutConstraint *tableBottom = [self.tableView.bottomAnchor constraintEqualToAnchor:self.inputMessageView.topAnchor];
    
    [NSLayoutConstraint activateConstraints:@[tableTrailing, tableLeading, tableTop, tableBottom]];
    
    NSLayoutConstraint *nmCenterX = [self.messageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0];
    NSLayoutConstraint *nmBottom = [self.messageView.bottomAnchor constraintEqualToAnchor:self.attachmentsView.topAnchor constant:-8];
    NSLayoutConstraint *nmHeight = [self.messageView.heightAnchor constraintEqualToConstant:44];
    
    [NSLayoutConstraint activateConstraints:@[nmCenterX, nmBottom, nmHeight]];
}

- (void)showNewMessageView:(BOOL)show completion:(void (^ _Nullable)(void))completion {
    if ((self.messageView.isVisible && show) || (!self.messageView.isVisible && !show)) {
        if (completion) {
            completion();
        }
    } else if (show) {
        [self.messageView showWithCompletion:^{
            if (completion) {
                completion();
            }
        }];
    } else if (!show) {
        [self.messageView hideWithCompletion:^{
            if (completion) {
                completion();
            }
        }];
    }
}

- (void)hideAttachmentsWithCompletion:(void (^)(void))completion {
    CGFloat alpha = 0.0;
    if (alpha == self.attachmentsView.alpha) {
        completion();
        return;
    }
    
    [UIView animateWithDuration:0.33 animations:^{
        self.attachmentsView.alpha = alpha;
    } completion:^(BOOL finished) {
        self.attachmentsView.isShown = NO;
        if (completion) {
            completion();
        }
    }];
}

- (void)updateSendButtonState {
    _inputMessageView.sendButton.enabled = ![_inputMessageView.inputTextView.text isEqualToString:@""] || ![self.attachmentsView isEmpty];
}

- (void)reloadAttachments {
    [self.attachmentsView reload];
}

- (void)showAttachmentsWithCompletion:(void (^)(void))completion {
    CGFloat alpha = 1.0;
    if (alpha == self.attachmentsView.alpha) {
        completion();
        return;
    }
    
    [UIView animateWithDuration:0.33 animations:^{
        self.attachmentsView.alpha = alpha;
    } completion:^(BOOL finished) {
        self.attachmentsView.isShown = YES;
        if (completion) {
            completion();
        }
    }];
}

- (void)animateOnKeyboardChangeWithNotification:(NSNotification *)notification completion:(void(^)(void))completion {
    NSDictionary<NSString *, id> *userInfo = notification.userInfo;
    NSString *name = notification.name;
    UIViewAnimationCurve curve = (UIViewAnimationCurve)userInfo[UIKeyboardAnimationCurveUserInfoKey];
    NSTimeInterval duration = (NSTimeInterval)[(NSNumber *)userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endFrame = [(NSValue *)userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ([name isEqualToString:UIKeyboardWillShowNotification]) {
        [self.animatableConstraint setConstant:-endFrame.size.height];
    } else {
        [self.animatableConstraint setConstant:0.0];
    }
    [UIView animateWithDuration:duration delay:0.0 options: curve << 16 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    if (self.tableView.contentSize.height < self.tableView.bounds.size.height) {
        return;
    }
    CGFloat offset = self.tableView.contentSize.height + self.tableView.contentInset.bottom;
    [self.tableView setContentOffset:CGPointMake(0.0, offset) animated:animated];
}

- (CGFloat)adjustedContentInsetWithAdditionalHeight:(CGFloat)height {
    CGFloat offset = self.attachmentsView.alpha == 0.0 ? 0.0 + height : self.attachmentsView.bounds.size.height + height;
    return offset;
}

- (void)adjustTableViewContentInset {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, [self adjustedContentInsetWithAdditionalHeight:0], 0);
    [self layoutIfNeeded];
}

@end

