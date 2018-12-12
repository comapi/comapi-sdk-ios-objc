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

#import "CMPTitledInputCell.h"

@implementation CMPTitledInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.titledTextField = [[CMPTitledTextField alloc] init];
        
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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColor.grayColor;
    
    self.titledTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    __weak typeof(self) weakSelf = self;
    self.titledTextField.didChangeText = ^(NSString * text) {
        weakSelf.didChangeText(text);
    };
}

- (void)layout {
    [self.contentView addSubview:self.titledTextField];
}

- (void)constrain {
    NSLayoutConstraint *top = [self.titledTextField.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8];
    NSLayoutConstraint *bottom = [self.titledTextField.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8];
    NSLayoutConstraint *leading = [self.titledTextField.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8];
    NSLayoutConstraint *trailing = [self.titledTextField.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8];
    
    [NSLayoutConstraint activateConstraints:@[top, bottom, leading, trailing]];
}

- (void)configureWithTitle:(NSString *)title value:(NSString *)value {
    [self.titledTextField setupWithTitle:title value:value];
}

@end
