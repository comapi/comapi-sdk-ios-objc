//
// The MIT License (MIT)
// Copyright (c) 2017 Comapi (trading name of Dynmark International Limited)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "CMPConversationsViewController.h"
#import "CMPTitledCell.h"
#import "CMPCreateConversationViewController.h"
#import "CMPChatViewController.h"

@interface CMPConversationsViewController ()

@end

@implementation CMPConversationsViewController

- (instancetype)initWithViewModel:(CMPConversationsViewModel *)viewModel {
    self = [super init];
    
    if (self) {
        _viewModel = viewModel;
        
        [self delegates];
        [self navigation];
    }
    
    return self;
}

- (CMPConversationsView *)conversationsView {
    return (CMPConversationsView *)self.view;
}

- (void)loadView {
    self.view = [[CMPConversationsView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    __weak typeof(self) weakSelf = self;
    [self.viewModel getConversationsWithCompletion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
        [weakSelf reload];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)delegates {
    self.conversationsView.tableView.delegate = self;
    self.conversationsView.tableView.dataSource = self;
}

- (void)navigation {
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.title = self.viewModel.profile.id;
    
    UIButton *createButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [createButton setImage:[UIImage imageNamed:@"add"] forState:0];
    [createButton addTarget:self action:@selector(createConversation) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *logoutBarButton = [[UIBarButtonItem alloc] initWithCustomView:createButton];
    
    self.navigationItem.rightBarButtonItem = logoutBarButton;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:0];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
}

- (void)createConversation {
    CMPCreateConversationViewModel *vm = [[CMPCreateConversationViewModel alloc] initWithClient:self.viewModel.client];
    CMPCreateConversationViewController *vc = [[CMPCreateConversationViewController alloc] initWithViewModel:vm];
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)reload {
    [self.conversationsView.tableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMPTitledCell *cell = (CMPTitledCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    CMPConversation *conversation = self.viewModel.conversations[indexPath.row];
    [cell configureWithTitle:conversation.id state:CMPPRofileStateOther];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.conversations.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CMPConversation *conversation = _viewModel.conversations[indexPath.row];
    CMPChatViewModel *vm = [[CMPChatViewModel alloc] initWithClient:_viewModel.client conversation:conversation];
    CMPChatViewController *vc = [[CMPChatViewController alloc] initWithViewModel:vm];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
