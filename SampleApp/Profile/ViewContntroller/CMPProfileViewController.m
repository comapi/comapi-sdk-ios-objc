//
//  CMPProfileViewController.m
//  SampleApp
//
//  Created by Dominik Kowalski on 12/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPProfileViewController.h"
#import "CMPTitledCell.h"
#import "CMPProfile.h"
#import "AppDelegate.h"

@interface CMPProfileViewController ()

@end

@implementation CMPProfileViewController

- (instancetype)initWithViewModel:(CMPProfileViewModel *)viewModel {
    self = [super init];
    
    if (self) {
        _viewModel = viewModel;
        
        [self delegates];
        [self navigation];
    }
    
    return self;
}

- (CMPProfileView *)profileView {
    return (CMPProfileView *)self.view;
}

- (void)loadView {
    self.view = [[CMPProfileView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    [self.viewModel getProfilesWithCompletion:^(NSError * _Nullable err) {
        [weakSelf reload];
    }];
}

- (void)delegates {
    self.profileView.tableView.delegate = self;
    self.profileView.tableView.dataSource = self;
}

- (void)navigation {
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.title = @"Profiles";
    
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [logoutButton setImage:[UIImage imageNamed:@"cancel"] forState:0];
    [logoutButton addTarget:self action:@selector(logoutTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *logoutBarButton = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
    
    self.navigationItem.rightBarButtonItem = logoutBarButton;
}

- (void)logoutTapped {
    AppDelegate *appDel = (AppDelegate *)UIApplication.sharedApplication.delegate;
    [appDel.configurator restart];
}

- (void)reload {
    [self.profileView.tableView reloadData];
}

// MARK: - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMPTitledCell *cell = (CMPTitledCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    CMPProfile *profile = self.viewModel.profiles[indexPath.row];
    [cell configureWithTitle:profile.id];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.profiles.count;
}


@end
