//
//  CMPProfileView.h
//  SampleApp
//
//  Created by Dominik Kowalski on 12/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseView.h"

@interface CMPProfileView : CMPBaseView <CMPViewConfiguring>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *notificationInfoLabel;
@property (nonatomic, strong) UISwitch *notificationSwitch;

@property (nonatomic, copy, nullable) void(^didChangeSwitchValue)(void);

- (instancetype)init;

@end
