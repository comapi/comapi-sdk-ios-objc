//
//  CMPChatView.m
//  SampleApp
//
//  Created by Dominik Kowalski on 15/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPChatView.h"
#import "CMPChatTextMessageCell.h"

@implementation CMPChatView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.tableView = [UITableView new];
        self.inputMessageView = [[CMPChatInputView alloc] init];
        
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
    [self.tableView registerClass:CMPChatTextMessageCell.class forCellReuseIdentifier:@"textCell"];
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
        [weakSelf scrollToBottomAnimated:YES];
        weakSelf.inputMessageView.sendButton.enabled = ![textView.text isEqualToString:@""];
    };
    self.inputMessageView.didTapUploadButton = ^{
        if (weakSelf.didTapUploadButton) {
            weakSelf.didTapUploadButton();
        }
    };
    self.inputMessageView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layout {
    [self addSubview:self.tableView];
    [self addSubview:self.inputMessageView];
}

- (void)constrain {
    NSLayoutConstraint *inputTrailing = [self.inputMessageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    NSLayoutConstraint *inputLeading = [self.inputMessageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    self.animatableConstraint = [self.inputMessageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    
    [NSLayoutConstraint activateConstraints:@[inputTrailing, inputLeading, self.animatableConstraint]];
    
    NSLayoutConstraint *tableTrailing = [self.tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    NSLayoutConstraint *tableLeading = [self.tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    NSLayoutConstraint *tableTop = [self.tableView.topAnchor constraintEqualToAnchor:self.topAnchor];
    NSLayoutConstraint *tableBottom = [self.tableView.bottomAnchor constraintEqualToAnchor:self.inputMessageView.topAnchor];
    
    [NSLayoutConstraint activateConstraints:@[tableTrailing, tableLeading, tableTop, tableBottom]];
}

- (void)animateOnKeyboardChangeWithNotification:(NSNotification *)notification completion:(void(^)(void))completion {
    NSDictionary<NSString *, id> *userInfo = notification.userInfo;
    NSString *name = notification.name;
    UIViewAnimationCurve curve = (UIViewAnimationCurve)userInfo[UIKeyboardAnimationCurveUserInfoKey];
    NSTimeInterval duration = (NSTimeInterval)[(NSNumber *)userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endFrame = [(NSValue *)userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration delay:0.0 options: curve << 16 animations:^{
        if ([name isEqualToString:UIKeyboardWillShowNotification]) {
            [self.animatableConstraint setConstant:-endFrame.size.height];
        } else {
            [self.animatableConstraint setConstant:0.0];
        }
        self.tableView.contentInset = UIEdgeInsetsZero;
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
    CGFloat offset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
    [self.tableView setContentOffset:CGPointMake(0.0, offset) animated:animated];
}

- (void)adjustTableViewContentInset {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.inputMessageView.bounds.size.height, 0);
    [self layoutIfNeeded];
}

@end

