//
//  CMPAddParticipantsViewController.h
//  SampleApp
//
//  Created by Dominik Kowalski on 17/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseViewController.h"
#import "CMPAddParticipantsView.h"
#import "CMPAddParticipantsViewModel.h"
#import "CMPViewControllerConfiguring.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPAddParticipantsViewController : CMPBaseViewController <CMPViewControllerConfiguring, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CMPAddParticipantsViewModel *viewModel;

- (instancetype)initWithViewModel:(CMPAddParticipantsViewModel *)viewModel;
- (CMPAddParticipantsView *)addParticipantsView;

@end

NS_ASSUME_NONNULL_END
