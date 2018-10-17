//
//  CMPAddParticipantsViewController.m
//  SampleApp
//
//  Created by Dominik Kowalski on 17/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
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
