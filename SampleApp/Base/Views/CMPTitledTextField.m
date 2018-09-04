//
//  CMPTitledTextField.m
//  SampleApp
//
//  Created by Dominik Kowalski on 31/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPTitledTextField.h"

@implementation CMPTitledTextField

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    [self configure];
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
    
    self.textField.backgroundColor = UIColor.whiteColor;
    self.textField.layer.borderWidth = 1;
    self.textField.layer.borderColor = [UIColor.whiteColor CGColor];
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    
    __weak CMPTitledTextField *weakSelf = self;
    self.didChangeText = ^(NSString * text) {
        weakSelf.didChangeText(text);
    };
}

- (void)layout {
    [self addSubview:self.titleLabel];
    [self addSubview:self.textField];
}

- (void)constrain {
    NSLayoutConstraint *titleTop = [self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor];
    NSLayoutConstraint *titleBottom = [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    NSLayoutConstraint *titleLeading = [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    NSLayoutConstraint *titleTrailing = [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    
    [NSLayoutConstraint activateConstraints:@[titleTop, titleBottom, titleLeading, titleTrailing]];
    
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
