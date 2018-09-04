//
//  CMPPlaceholderTextView.m
//  SampleApp
//
//  Created by Dominik Kowalski on 31/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPPlaceholderTextView.h"
#import "UIToolbar+CMPUtilities.h"

@implementation CMPPlaceholderTextView

- (instancetype)init {
    self = [super initWithFrame:CGRectZero textContainer:nil];
    [self configure];
    return self;
}

- (void)configure {
    self.delegate = self;
    self.keyboardAppearance = UIKeyboardAppearanceDark;
    self.textColor = UIColor.whiteColor;
    self.textContainerInset = UIEdgeInsetsMake(10, 6, 0, 10);
    self.backgroundColor = UIColor.clearColor;
    self.font = [UIFont systemFontOfSize:14];
    self.layer.cornerRadius = 4;
    self.layer.borderWidth = 1;
    self.layer.borderColor = UIColor.whiteColor.CGColor;
    self.inputAccessoryView = [UIToolbar toolbarWithTitle:@"Dismiss" target:self action:@selector(dismiss)];
    
    self.placeholderLabel = [UILabel new];
    self.placeholderLabel.font = [UIFont systemFontOfSize:14];
    self.placeholderLabel.numberOfLines = 0;
    self.placeholderLabel.textColor = UIColor.whiteColor;
    self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.placeholderLabel];
    
    NSLayoutConstraint *top = [[self.placeholderLabel topAnchor] constraintEqualToAnchor: self.topAnchor];
    NSLayoutConstraint *leading = [[self.placeholderLabel leadingAnchor] constraintEqualToAnchor: self.leadingAnchor];
    NSLayoutConstraint *trailing = [[self.placeholderLabel trailingAnchor] constraintEqualToAnchor: self.trailingAnchor];
    
    [NSLayoutConstraint activateConstraints:@[top, leading, trailing]];
}

- (void)setPlaceholderWithText:(NSString *)text {
    self.placeholderLabel.text = text;
}

- (void)clearInput {
    self.text = @"";
    [self.placeholderLabel setHidden:NO];
}

- (void)dismiss {
    [self resignFirstResponder];
}

// MARK: - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    [self.placeholderLabel setHidden: ![textView.text isEqualToString:@""]];
    
    self.didChangeText(textView);
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.didBeginEditing(textView);
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.didEndEditing(textView);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        self.didReturnTap(textView);
    }
    
    return YES;
}

@end
