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

#import "CMPTitledTextField.h"

@implementation CMPTitledTextField

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.textField = [[CMPInsetTextField alloc] init];
        
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
    self.titleLabel.backgroundColor = UIColor.clearColor;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = UIColor.whiteColor;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.backgroundColor = UIColor.whiteColor;
    self.textField.layer.borderWidth = 1;
    self.textField.layer.borderColor = [UIColor.grayColor CGColor];
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    
    __weak CMPTitledTextField *weakSelf = self;
    self.textField.didChangeText = ^(NSString * text) {
        weakSelf.didChangeText(text);
    };
}

- (void)layout {
    [self addSubview:self.titleLabel];
    [self addSubview:self.textField];
}

- (void)constrain {
    NSLayoutConstraint *titleTop = [self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor];
    NSLayoutConstraint *titleLeading = [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    NSLayoutConstraint *titleTrailing = [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    
    [NSLayoutConstraint activateConstraints:@[titleTop, titleLeading, titleTrailing]];
    
    NSLayoutConstraint *textFieldTop = [self.textField.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:8];
    NSLayoutConstraint *textFieldBottom = [self.textField.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    NSLayoutConstraint *textFieldLeading = [self.textField.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    NSLayoutConstraint *textFieldTrailing = [self.textField.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    NSLayoutConstraint *textFieldHeight = [self.textField.heightAnchor constraintGreaterThanOrEqualToConstant:40];
    
    [NSLayoutConstraint activateConstraints:@[textFieldTop, textFieldBottom, textFieldLeading, textFieldTrailing, textFieldHeight]];
}

- (void)clear {
    self.textField.text = @"";
}

- (void)setupWithTitle:(NSString *)title value:(NSString *)value {
    self.titleLabel.text = title;
    self.textField.text = value;
}

- (void)editingEnabled:(BOOL)enabled {
    [self.textField setEnabled:enabled];
}

- (void)textChanged {
    self.didChangeText(self.textField.text);
}

- (void)dismiss {
    [self.textField resignFirstResponder];
}

@end
