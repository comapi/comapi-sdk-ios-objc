//
//  CMPProfileDetailsViewController.m
//  SampleApp
//
//  Created by Dominik Kowalski on 19/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPProfileDetailsViewController.h"
#import "CMPTitledInputCell.h"
#import "CMPProfileViewController.h"

@interface CMPProfileDetailsViewController ()

@end

@implementation CMPProfileDetailsViewController

- (instancetype)initWithViewModel:(CMPProfileDetailsViewModel *)viewModel state:(CMPProfileState)state {
    self = [super init];
    
    if (self) {
        _viewModel = viewModel;
        _state = state;
        
        [self navigation];
        [self delegates];
    }
    
    return self;
}

- (void)loadView {
    self.view = [[CMPProfileDetailsView alloc] initWithState:self.state];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForLoadingNotifcations];
    [self reload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unregisterFromLoadingNotifications];
}

- (CMPProfileDetailsView *)profileDetailsView {
    return (CMPProfileDetailsView *)self.view;
}

- (void)navigation {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
}

- (void)delegates {
    self.profileDetailsView.tableView.delegate = self;
    self.profileDetailsView.tableView.dataSource = self;
    
    __weak typeof(self) weakSelf = self;
    
    self.profileDetailsView.didTapClose = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    self.profileDetailsView.didTapUpdate = ^{
        [weakSelf.viewModel updateEmail:weakSelf.viewModel.email completion:^(NSError * _Nullable error) {
            if (error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error updating email" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            } else {
                CMPProfileViewController *vc = (CMPProfileViewController *)[((UINavigationController *)weakSelf.presentingViewController).viewControllers lastObject];
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    [vc.viewModel getProfilesWithCompletion:^(NSError * _Nullable err) {
                        [vc reload];
                    }];
                }];
            }
        }];
    };
}

- (void)reload {
    [self.profileDetailsView.tableView reloadData];
}

// MARK: - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMPTitledInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell configureWithTitle:@"Email" value:self.viewModel.profile.email];
    __weak typeof(self) weakSelf = self;
    cell.didChangeText = ^(NSString * text) {
        [weakSelf.viewModel setEmail:text];
    };
    return cell;
}

@end
