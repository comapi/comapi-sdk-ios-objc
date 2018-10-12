//
//  CMPConversationsViewController.m
//  SampleApp
//
//  Created by Dominik Kowalski on 12/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPConversationsViewController.h"
#import "CMPTitledCell.h"

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
    
}

- (void)reload {
    [self.conversationsView.tableView reloadData];
}

// MARK: - UITableViewDelegate & UITableViewDataSource

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

}

@end
