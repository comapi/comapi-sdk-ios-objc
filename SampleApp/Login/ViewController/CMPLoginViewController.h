//
//  CMPLoginViewController.h
//  SampleApp
//
//  Created by Dominik Kowalski on 04/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseViewController.h"
#import "CMPLoginView.h"

@interface CMPLoginViewController : CMPBaseViewController

@property (nonatomic, strong) CMPLoginView *loginView;
@property (nonatomic, strong, readonly) *viewModel;

@end
