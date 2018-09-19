//
//  CMPProfileDetailsView.h
//  SampleApp
//
//  Created by Dominik Kowalski on 19/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseView.h"

typedef NS_ENUM(NSUInteger, CMPProfileState) {
    CMPProfileStateSelf,
    CMPPRofileStateOther
};

@interface CMPProfileDetailsView : CMPBaseView

@property (nonatomic) CMPProfileState state;

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *updateButton;

@property (nonatomic, copy) void(^didTapClose)(void);
@property (nonatomic, copy) void(^didTapUpdate)(void);

- (instancetype)initWithState:(CMPProfileState)state;

@end
