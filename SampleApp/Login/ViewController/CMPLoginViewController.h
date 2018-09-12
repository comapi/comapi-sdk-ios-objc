//
//  CMPLoginViewController.h
//  SampleApp
//
//  Created by Dominik Kowalski on 04/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseViewController.h"
#import "CMPLoginView.h"
#import "CMPLoginViewModel.h"
#import "CMPViewControllerConfiguring.h"

@interface CMPLoginViewController : CMPBaseViewController <CMPViewControllerConfiguring, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readonly) CMPLoginViewModel *viewModel;

- (CMPLoginView *)loginView;
- (instancetype)initWithViewModel:(CMPLoginViewModel *)viewModel;

@end
