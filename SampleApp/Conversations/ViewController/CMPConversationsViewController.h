//
//  CMPConversationsViewController.h
//  SampleApp
//
//  Created by Dominik Kowalski on 12/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseViewController.h"
#import "CMPViewControllerConfiguring.h"
#import "CMPConversationsViewModel.h"
#import "CMPConversationsView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPConversationsViewController : CMPBaseViewController <CMPViewControllerConfiguring, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readonly) CMPConversationsViewModel *viewModel;

- (instancetype)initWithViewModel:(CMPConversationsViewModel *)viewModel;

- (CMPConversationsView *)conversationsView;
- (void)reload;

@end

NS_ASSUME_NONNULL_END
