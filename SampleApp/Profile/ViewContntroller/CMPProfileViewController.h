//
//  CMPProfileViewController.h
//  SampleApp
//
//  Created by Dominik Kowalski on 12/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseViewController.h"
#import "CMPProfileView.h"
#import "CMPProfileViewModel.h"
#import "CMPViewControllerConfiguring.h"


@interface CMPProfileViewController : CMPBaseViewController <CMPViewControllerConfiguring, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readonly) CMPProfileViewModel *viewModel;

- (CMPProfileView *)profileView;
- (instancetype)initWithViewModel:(CMPProfileViewModel *)viewModel;

@end
