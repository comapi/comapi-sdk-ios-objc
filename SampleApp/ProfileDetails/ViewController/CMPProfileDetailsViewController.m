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

#pragma mark - UITableViewDelegate & UITableViewDataSource

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
