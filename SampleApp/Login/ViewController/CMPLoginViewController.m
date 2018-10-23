//
//  CMPLoginViewController.m
//  SampleApp
//
//  Created by Dominik Kowalski on 04/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPLoginViewController.h"

@interface CMPLoginViewController ()

@end

@implementation CMPLoginViewController

- (instancetype)initWithViewModel:(CMPLoginViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        [self navigation];
        [self delegates];
    }
    
    return self;
}

- (CMPLoginView *)loginView {
    return (CMPLoginView *)self.view;
}

- (void)loadView {
    self.view = [[CMPLoginView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
    [self registerForLoadingNotifcations];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self unregisterFromKeyboardNotifications];
    [self unregisterFromLoadingNotifications];
}

- (void)delegates {
    self.loginView.tableView.delegate = self;
    self.loginView.tableView.dataSource = self;
    
    __weak typeof(self) weakSelf = self;
    self.loginView.didTapLoginButton = ^{
        [weakSelf.viewModel configureWithCompletion:^(NSError * _Nullable err) {
            if (err) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login info error" message:err.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [weakSelf.navigationController presentViewController:alert animated:YES completion:nil];
            } else {
                CMPProfileViewModel *vm = [[CMPProfileViewModel alloc] initWithClient:self.viewModel.client];
                CMPProfileViewController *vc = [[CMPProfileViewController alloc] initWithViewModel:vm];
                
                UINavigationController *nav = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
                [nav pushViewController:vc animated:true];
            }
        }];
    };
    
    self.keyboardWillHide = ^(NSNotification * _Nonnull notif) {
        [weakSelf.loginView animateOnKeyboardChangeNotification:notif completion:nil];
    };
    
    self.keyboardWillShow = ^(NSNotification * _Nonnull notif) {
        [weakSelf.loginView animateOnKeyboardChangeNotification:notif completion:nil];
    };
}

- (void)navigation {
    self.navigationItem.title = @"Login";
}

- (void)reload {
    [self.loginView.tableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMPTitledInputCell *cell = (CMPTitledInputCell *)[tableView dequeueReusableCellWithIdentifier:@"inputCell" forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0: {
            [cell configureWithTitle:@"Api-Space-ID" value:self.viewModel.loginBundle.apiSpaceID];
            cell.didChangeText = ^(NSString * text) {
                weakSelf.viewModel.loginBundle.apiSpaceID = text;
            };
            return cell;
        }
        case 1: {
            [cell configureWithTitle:@"Profile-ID" value:self.viewModel.loginBundle.profileID];
            cell.didChangeText = ^(NSString * text) {
                weakSelf.viewModel.loginBundle.profileID = text;
            };
            return cell;
        }
        case 2: {
            [cell configureWithTitle:@"Issuer" value:self.viewModel.loginBundle.issuer];
            cell.didChangeText = ^(NSString * text) {
                weakSelf.viewModel.loginBundle.issuer = text;
            };
            return cell;
        }
        case 3: {
            [cell configureWithTitle:@"Audience" value:self.viewModel.loginBundle.audience];
            cell.didChangeText = ^(NSString * text) {
                weakSelf.viewModel.loginBundle.audience = text;
            };
            return cell;
        }
        case 4: {
            [cell configureWithTitle:@"Secret" value:self.viewModel.loginBundle.secret];
            cell.didChangeText = ^(NSString * text) {
                weakSelf.viewModel.loginBundle.secret = text;
            };
            return cell;
        }
        default:
            return [UITableViewCell new];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

@end
