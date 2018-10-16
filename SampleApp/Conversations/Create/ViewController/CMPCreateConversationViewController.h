//
//  CreateConversationViewController.h
//  SampleApp
//
//  Created by Dominik Kowalski on 15/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseViewController.h"
#import "CMPCreateConversationView.h"
#import "CMPCreateConversationViewModel.h"
#import "CMPViewControllerConfiguring.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPCreateConversationViewController : CMPBaseViewController <CMPViewControllerConfiguring, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CMPCreateConversationViewModel *viewModel;

- (instancetype)initWithViewModel:(CMPCreateConversationViewModel *)viewModel;
- (CMPCreateConversationView *)conversationView;

@end

NS_ASSUME_NONNULL_END
