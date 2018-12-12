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
    
    NSLayoutConstraint *top = [[self.placeholderLabel topAnchor] constraintEqualToAnchor: self.topAnchor constant:10];
    NSLayoutConstraint *leading = [[self.placeholderLabel leadingAnchor] constraintEqualToAnchor: self.leadingAnchor constant:10];
    NSLayoutConstraint *trailing = [[self.placeholderLabel trailingAnchor] constraintEqualToAnchor: self.trailingAnchor constant:-10];
    
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

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    [self.placeholderLabel setHidden: ![textView.text isEqualToString:@""]];
    if (self.didChangeText) {
        self.didChangeText(textView);
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.didBeginEditing) {
        self.didBeginEditing(textView);
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.didEndEditing) {
        self.didEndEditing(textView);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"] && self.didReturnTap) {
        self.didReturnTap(textView);
    }
    
    return YES;
}

@end
