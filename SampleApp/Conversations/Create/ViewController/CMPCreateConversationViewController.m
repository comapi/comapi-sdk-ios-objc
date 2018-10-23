//
//  CMPCreateConversationViewController.m
//  SampleApp
//
//  Created by Dominik Kowalski on 15/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPCreateConversationViewController.h"
#import "CMPConversationsViewController.h"
#import "CMPTitledInputCell.h"

@interface CMPCreateConversationViewController ()

@end

@implementation CMPCreateConversationViewController

- (instancetype)initWithViewModel:(CMPCreateConversationViewModel *)viewModel {
    self = [super init];
    
    if (self) {
        self.viewModel = viewModel;
        
        [self delegates];
        [self navigation];
    }
    
    return self;
}

- (CMPCreateConversationView *)conversationView {
    return (CMPCreateConversationView *)self.view;
}

- (void)loadView {
    self.view = [[CMPCreateConversationView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.viewModel getProfilesWithCompletion:^(NSArray<CMPProfile *> * _Nullable profiles, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            [self reload];
        }
    }];
}

- (void)delegates {
    self.conversationView.tableView.delegate = self;
    self.conversationView.tableView.dataSource = self;
    
    __weak typeof(self) weakSelf = self;
    self.conversationView.didTapClose = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    self.conversationView.didTapCreate = ^{
        [weakSelf.viewModel createConversation:NO completion:^(BOOL exists, CMPConversation * _Nullable conversation, NSError * _Nullable error) {
            if (error ) {
                NSLog(@"%@", error.localizedDescription);
            }
            if (exists) {
                NSLog(@"conversation already exists");
            }
            
            UINavigationController *presenter = (UINavigationController *)self.presentingViewController;
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                CMPConversationsViewController *vc = (CMPConversationsViewController *)presenter.viewControllers.lastObject;
                [vc.viewModel getConversationsWithCompletion:^(NSError * _Nullable error) {
                    [vc reload];
                }];
            }];
        }];
    };
}

- (void)navigation {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
}

- (void)reload {
    [self.conversationView.tableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMPTitledInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0: {
            [cell configureWithTitle:@"Name" value:@""];
            cell.didChangeText = ^(NSString * text) {
                self.viewModel.conversation.name = text;
            };
            break;
        }
        case 1: {
            [cell configureWithTitle:@"Description" value:@""];
            cell.didChangeText = ^(NSString * text) {
                self.viewModel.conversation.conversationDescription = text;
            };
            break;
        }
        default:
            break;
    }
    
    return cell;
}

@end
