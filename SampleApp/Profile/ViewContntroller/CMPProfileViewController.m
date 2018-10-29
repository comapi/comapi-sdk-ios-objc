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


#import "CMPProfileViewController.h"
#import "CMPTitledCell.h"
#import "CMPProfile.h"
#import "AppDelegate.h"
#import "CMPProfileDetailsViewController.h"

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifcationStatusChanged:) name:kCMPPushRegistrationStatusChangedNotification object:nil];
    
    __weak typeof(self) weakSelf = self;
    [self.viewModel getProfilesWithCompletion:^(NSError * _Nullable err) {
        [weakSelf reload];
        [weakSelf.viewModel registerForRemoteNotificationsWithCompletion:^(BOOL success, NSError * _Nonnull error) {
            if (!error && success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIApplication.sharedApplication registerForRemoteNotifications];
                });
            }
        }];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCMPPushRegistrationStatusChangedNotification object:nil];
}

- (void)delegates {
    self.profileView.tableView.delegate = self;
    self.profileView.tableView.dataSource = self;
    
    self.profileView.didChangeSwitchValue = ^{
        NSLog(@"value changed");
    };
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

- (void)notifcationStatusChanged:(NSNotification *)notification {
    BOOL value = [(NSNumber *)notification.object boolValue];
    [self.profileView.notificationSwitch setOn:value];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMPTitledCell *cell = (CMPTitledCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    CMPProfile *profile = self.viewModel.profiles[indexPath.row];
    [cell configureWithTitle:profile.id state:profile.id == self.viewModel.client.profileID ? CMPProfileStateSelf : CMPPRofileStateOther];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.profiles.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CMPProfileDetailsViewModel *vm = [[CMPProfileDetailsViewModel alloc] initWithClient:self.viewModel.client profile:self.viewModel.profiles[indexPath.row]];
    CMPProfileDetailsViewController *vc = [[CMPProfileDetailsViewController alloc] initWithViewModel:vm state:self.viewModel.profiles[indexPath.row].id == self.viewModel.client.profileID ? CMPProfileStateSelf : CMPPRofileStateOther];
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

@end
