//
//  CMPTitledInputCell.m
//  SampleApp
//
//  Created by Dominik Kowalski on 04/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
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
    
    __weak typeof(self) weakSelf = self;
    self.titledTextField.didChangeText = ^(NSString * text) {
        weakSelf.didChangeText(text);
    };
}

- (void)layout {
    [self.contentView addSubview:self.titledTextField];
}

- (void)constrain {
    NSLayoutConstraint *top = [self.titledTextField.topAnchor constraintEqualToAnchor:self.topAnchor constant:8];
    NSLayoutConstraint *bottom = [self.titledTextField.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8];
    NSLayoutConstraint *leading = [self.titledTextField.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:-8];
    NSLayoutConstraint *trailing = [self.titledTextField.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:8];
    
    [NSLayoutConstraint activateConstraints:@[top, bottom, leading, trailing]];
}

- (void)configureWithTitle:(NSString *)title value:(NSString *)value {
    [self.titledTextField setupWithTitle:title value:value];
}

@end
