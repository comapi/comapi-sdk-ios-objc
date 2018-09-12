//
//  CMPProfileViewController.m
//  SampleApp
//
//  Created by Dominik Kowalski on 12/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPProfileViewController.h"
#import "CMPTitledCell.h"

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
}

- (void)delegates {
    self.profileView.tableView.delegate = self;
    self.profileView.tableView.dataSource = self;
}

- (void)navigation {
    self.navigationItem.title = @"Profiles";
}

- (void)reload {
    [self.profileView.tableView reloadData];
}

// MARK - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMPTitledCell *cell = (CMPTitledCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0: {
            [cell configureWithTitle:@""];

            return cell;
        }
        case 1: {
            
            return cell;
        }
        case 2: {
            
            return cell;
        }
        case 3: {
            
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
