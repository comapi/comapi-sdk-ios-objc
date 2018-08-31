//
//  CMPGrayButtonWithWhiteText.m
//  SampleApp
//
//  Created by Dominik Kowalski on 31/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPGrayButtonWithWhiteText.h"

@implementation CMPGrayButtonWithWhiteText

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    [self configure];
    return self;
}

- (void)configure {
    [self backgroundColor] = UIColor.whiteColor;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    [self setTitleColor:UIColor.grayColor forState:0];
    self.layer.shadowColor = [UIColor.blackColor CGColor];
    self.layer.shadowOffset = CGSizeMake(0, 4);
    self.layer.shadowRadius = 4.0;
    self.layer.shadowOpacity = 0.14;
    self.layer.cornerRadius = 4.0;
}

@end
