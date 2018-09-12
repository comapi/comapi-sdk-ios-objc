//
//  CMPTitledCell.m
//  SampleApp
//
//  Created by Dominik Kowalski on 12/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPTitledCell.h"

@implementation CMPTitledCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.mainTitleLabel = [UILabel new];
        
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
    
    self.mainTitleLabel.backgroundColor = UIColor.grayColor;
    self.mainTitleLabel.textColor = UIColor.whiteColor;
    self.mainTitleLabel.layer.borderColor = UIColor.whiteColor.CGColor;
    self.mainTitleLabel.layer.borderWidth = 1.0;
    self.mainTitleLabel.layer.cornerRadius = 4.0;
    self.mainTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layout {
    [self.contentView addSubview:self.mainTitleLabel];
}

- (void)constrain {
    NSLayoutConstraint *top = [self.titledTextField.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8];
    NSLayoutConstraint *bottom = [self.titledTextField.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8];
    NSLayoutConstraint *leading = [self.titledTextField.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8];
    NSLayoutConstraint *trailing = [self.titledTextField.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8];
    
    [NSLayoutConstraint activateConstraints:@[top, bottom, leading, trailing]];
}

- (void)configureWithTitle:(NSString *)title {
    self.mainTitleLabel.text = title;
}
@end
