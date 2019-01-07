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
