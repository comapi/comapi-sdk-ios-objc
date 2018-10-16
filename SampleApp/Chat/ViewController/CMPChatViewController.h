//
//  CMPChatViewController.h
//  SampleApp
//
//  Created by Dominik Kowalski on 15/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseViewController.h"
#import "CMPViewControllerConfiguring.h"
#import "CMPChatViewModel.h"
#import "CMPChatView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPChatViewController : CMPBaseViewController <CMPViewControllerConfiguring, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readonly) CMPChatViewModel *viewModel;

- (instancetype)initWithViewModel:(CMPChatViewModel *)viewModel;

- (CMPChatView *)chatView;

@end

NS_ASSUME_NONNULL_END
