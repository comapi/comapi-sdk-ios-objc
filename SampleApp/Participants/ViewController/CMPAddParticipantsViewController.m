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

#import "CMPAddParticipantsViewController.h"
#import "CMPTitledInputCell.h"

@interface CMPAddParticipantsViewController ()

@end

@implementation CMPAddParticipantsViewController

- (instancetype)initWithViewModel:(CMPAddParticipantsViewModel *)viewModel {
    self = [super init];
    
    if (self) {
        _viewModel = viewModel;
        
        [self navigation];
        [self delegates];
    }
    
    return self;
}

- (CMPAddParticipantsView *)addParticipantsView {
    return (CMPAddParticipantsView *)self.view;
}

- (void)loadView {
    self.view = [[CMPAddParticipantsView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reload];
}

- (void)delegates {
    self.addParticipantsView.tableView.delegate = self;
    self.addParticipantsView.tableView.dataSource = self;
    
    __weak typeof(self) weakSelf = self;
    self.addParticipantsView.didTapAdd = ^{
        [weakSelf.viewModel addParticipantWithCompletion:^(BOOL success, NSError * _Nullable error) {
            if (!error && success) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            } else if (error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:actionOk];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
        }];
    };
    self.addParticipantsView.didTapClose = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
}

- (void)navigation {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
}

- (void)reload {
    [self.addParticipantsView.tableView reloadData];
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
    [cell configureWithTitle:@"Name" value:@""];
    __weak typeof(self) weakSelf = self;
    cell.didChangeText = ^(NSString * text) {
        [weakSelf.viewModel updateID:text];
    };
    return cell;
}

@end
