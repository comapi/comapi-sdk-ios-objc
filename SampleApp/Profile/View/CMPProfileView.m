//
//  CMPProfileView.m
//  SampleApp
//
//  Created by Dominik Kowalski on 12/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPProfileView.h"
#import "CMPTitledCell.h"

@implementation CMPProfileView 

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.tableView = [UITableView new];
        self.bottomView = [UIView new];
        self.notificationInfoLabel = [UILabel new];
        self.notificationSwitch = [UISwitch new];
        
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
    [self.tableView registerClass:CMPTitledCell.class forCellReuseIdentifier:@"cell"];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.bottomView.backgroundColor = UIColor.grayColor;
    self.bottomView.layer.borderColor = UIColor.whiteColor.CGColor;
    self.bottomView.layer.borderWidth = 1.0;
    self.bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.notificationInfoLabel.text = @"Notification status";
    self.notificationInfoLabel.textColor = UIColor.whiteColor;
    self.notificationInfoLabel.font = [UIFont systemFontOfSize:16];
    self.notificationInfoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.notificationSwitch setOn:NO];
    self.notificationSwitch.onTintColor = UIColor.blackColor;
    self.notificationSwitch.tintColor = UIColor.whiteColor;
    [self.notificationSwitch setEnabled:NO];
    [self.notificationSwitch addTarget:self action:@selector(switchValueChanged) forControlEvents:UIControlEventValueChanged];
    self.notificationSwitch.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layout {
    [self addSubview:self.tableView];
    
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.notificationInfoLabel];
    [self.bottomView addSubview:self.notificationSwitch];
}

- (void)constrain {
    NSLayoutConstraint *bottomViewBottom;
    
    if (@available(iOS 11.0, *)) {
        bottomViewBottom = [self.bottomView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor];
    } else {
        bottomViewBottom = [self.bottomView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    }
    
    NSLayoutConstraint *tableTop = [self.tableView.topAnchor constraintEqualToAnchor:self.topAnchor];
    NSLayoutConstraint *tableBottom = [self.tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    NSLayoutConstraint *tableLeading = [self.tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    NSLayoutConstraint *tableTrailing = [self.tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    
    [NSLayoutConstraint activateConstraints:@[tableTop, tableBottom, tableLeading, tableTrailing]];
    
    
    NSLayoutConstraint *bottomViewLeading = [self.bottomView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    NSLayoutConstraint *bottomViewTrailing = [self.bottomView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    
    [NSLayoutConstraint activateConstraints:@[bottomViewBottom, bottomViewLeading, bottomViewTrailing]];
    
    NSLayoutConstraint *infoLabelHeight = [self.notificationInfoLabel.heightAnchor constraintGreaterThanOrEqualToConstant:44];
    NSLayoutConstraint *infoLabelTop = [self.notificationInfoLabel.topAnchor constraintEqualToAnchor:self.bottomView.topAnchor constant:8];
    NSLayoutConstraint *infoLabelBottom = [self.notificationInfoLabel.bottomAnchor constraintEqualToAnchor:self.bottomView.bottomAnchor constant:-8];
    NSLayoutConstraint *infoLabelLeading = [self.notificationInfoLabel.leadingAnchor constraintEqualToAnchor:self.bottomView.leadingAnchor constant:16];
    NSLayoutConstraint *infoLabelTrailing = [self.notificationInfoLabel.trailingAnchor constraintEqualToAnchor:self.notificationSwitch.leadingAnchor constant:-16];
    
    [NSLayoutConstraint activateConstraints:@[infoLabelHeight, infoLabelTop, infoLabelBottom, infoLabelLeading, infoLabelTrailing]];
    
    NSLayoutConstraint *switchCenterY = [self.notificationSwitch.centerYAnchor constraintEqualToAnchor:self.bottomView.centerYAnchor];
    NSLayoutConstraint *switchTrailing = [self.notificationSwitch.trailingAnchor constraintEqualToAnchor:self.bottomView.trailingAnchor constant:-16];
    
    [NSLayoutConstraint activateConstraints:@[switchCenterY, switchTrailing]];
}

- (void)switchValueChanged {
    if (self.didChangeSwitchValue) {
        self.didChangeSwitchValue();
    }
}

@end
