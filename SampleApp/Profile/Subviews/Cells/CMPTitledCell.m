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


#import "CMPTitledCell.h"


@implementation CMPTitledCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.mainTitleLabel = [UILabel new];
        self.bubbleView = [UIView new];
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
    self.mainTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.bubbleView.backgroundColor = UIColor.grayColor;
    self.bubbleView.layer.borderColor = UIColor.whiteColor.CGColor;
    self.bubbleView.layer.borderWidth = 1.0;
    self.bubbleView.layer.cornerRadius = 4.0;
    self.bubbleView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layout {
    [self.contentView addSubview:self.bubbleView];
    [self.bubbleView addSubview:self.mainTitleLabel];
}

- (void)constrain {
    NSLayoutConstraint *bubbleTop = [self.bubbleView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8];
    NSLayoutConstraint *bubblBbottom = [self.bubbleView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8];
    NSLayoutConstraint *bubbleLeading = [self.bubbleView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8];
    NSLayoutConstraint *bubbleTrailing = [self.bubbleView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8];
    NSLayoutConstraint *height = [self.bubbleView.heightAnchor constraintGreaterThanOrEqualToConstant:40];
    
    [NSLayoutConstraint activateConstraints:@[bubbleTop, bubblBbottom, bubbleLeading, bubbleTrailing, height]];
    
    NSLayoutConstraint *top = [self.mainTitleLabel.topAnchor constraintEqualToAnchor:self.bubbleView.topAnchor];
    NSLayoutConstraint *bottom = [self.mainTitleLabel.bottomAnchor constraintEqualToAnchor:self.bubbleView.bottomAnchor];
    NSLayoutConstraint *leading = [self.mainTitleLabel.leadingAnchor constraintEqualToAnchor:self.bubbleView.leadingAnchor constant:8];
    NSLayoutConstraint *trailing = [self.mainTitleLabel.trailingAnchor constraintEqualToAnchor:self.bubbleView.trailingAnchor constant:-8];
    
    
    [NSLayoutConstraint activateConstraints:@[top, bottom, leading, trailing, height]];
}

- (void)configureWithTitle:(NSString *)title state:(CMPProfileState)state {
    self.mainTitleLabel.text = title;
    self.bubbleView.layer.borderColor = state == CMPProfileStateSelf ? UIColor.blackColor.CGColor : UIColor.whiteColor.CGColor;
    self.mainTitleLabel.textColor = state == CMPProfileStateSelf ? UIColor.blackColor : UIColor.whiteColor;
}

@end
