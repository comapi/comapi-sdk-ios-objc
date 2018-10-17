//
//  CMPAddParticipantsView.h
//  SampleApp
//
//  Created by Dominik Kowalski on 17/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPAddParticipantsView : CMPBaseView <CMPViewConfiguring>

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, copy) void(^didTapClose)(void);
@property (nonatomic, copy) void(^didTapAdd)(void);

@end

NS_ASSUME_NONNULL_END
