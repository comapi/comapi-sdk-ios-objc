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

#import "CMPLoginViewController.h"
#import "CMPConversationsViewController.h"

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
                [weakSelf.viewModel getProfileWithCompletion:^(CMPProfile * _Nullable profile, NSError * _Nullable error) {
                    CMPConversationsViewModel *vm = [[CMPConversationsViewModel alloc] initWithClient:weakSelf.viewModel.client profile:profile];
                    CMPConversationsViewController *vc = [[CMPConversationsViewController alloc] initWithViewModel:vm];
                    
                    UINavigationController *nav = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
                    [nav pushViewController:vc animated:YES];
                }];
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
