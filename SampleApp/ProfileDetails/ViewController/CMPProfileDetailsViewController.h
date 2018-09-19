//
//  CMPProfileDetailsViewController.h
//  SampleApp
//
//  Created by Dominik Kowalski on 19/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseViewController.h"
#import "CMPProfileDetailsView.h"
#import "CMPProfileDetailsViewModel.h"
#import "CMPViewControllerConfiguring.h"

@interface CMPProfileDetailsViewController : CMPBaseViewController <CMPViewControllerConfiguring, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) CMPProfileState state;
@property (nonatomic, strong, readonly) CMPProfileDetailsViewModel *viewModel;

- (CMPProfileDetailsView *)profileDetailsView;
- (instancetype)initWithViewModel:(CMPProfileDetailsViewModel *)viewModel state:(CMPProfileState)state;


@end
