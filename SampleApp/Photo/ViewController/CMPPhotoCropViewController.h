//
//  CMPPhotoCropViewController.h
//  SampleApp
//
//  Created by Dominik Kowalski on 19/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseViewController.h"
#import "CMPPhotoCropView.h"
#import "CMPPhotoCropViewModel.h"
#import "CMPViewControllerConfiguring.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPPhotoCropViewController : CMPBaseViewController <CMPViewControllerConfiguring>

@property (nonatomic, strong, readonly) CMPPhotoCropViewModel *viewModel;

- (instancetype)initWithViewModel:(CMPPhotoCropViewModel *)viewModel;
- (CMPPhotoCropView *)photoCropView;

@end

NS_ASSUME_NONNULL_END
