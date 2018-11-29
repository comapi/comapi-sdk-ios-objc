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

#import "CMPChatViewController.h"
#import "CMPChatTextMessageCell.h"
#import "CMPChatImageMessageCell.h"
#import "CMPAddParticipantsViewController.h"

@interface CMPChatViewController ()

@end

@implementation CMPChatViewController

- (instancetype)initWithViewModel:(CMPChatViewModel *)viewModel {
    self = [super init];
    
    if (self) {
        _viewModel = viewModel;
        
        [self navigation];
        [self delegates];
    }
    
    return self;
}

- (CMPChatView *)chatView {
    return (CMPChatView *)self.view;
}

- (void)loadView {
    self.view = [[CMPChatView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    [_viewModel getMessagesWithCompletion:^(NSArray<CMPMessage *> * _Nullable messages, NSError * _Nullable error) {
        [weakSelf reload];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unregisterFromKeyboardNotifications];
}

- (void)delegates {
    self.chatView.tableView.delegate = self;
    self.chatView.tableView.dataSource = self;
    
    __weak typeof(self) weakSelf = self;
    self.keyboardWillShow = ^(NSNotification * _Nonnull notif) {
        [weakSelf.chatView animateOnKeyboardChangeWithNotification:notif completion:nil];
    };
    self.keyboardWillHide = ^(NSNotification * _Nonnull notif) {
        [weakSelf.chatView animateOnKeyboardChangeWithNotification:notif completion:nil];
    };
    self.chatView.didTapSendButton = ^(NSString * _Nonnull text) {
        [weakSelf.viewModel sendTextMessage:text completion:^(NSError * _Nullable err) {
            [weakSelf reload];
        }];
    };
    self.chatView.didTapUploadButton = ^{
        [weakSelf.viewModel showPhotoSourceControllerWithPresenter:^(UIViewController * _Nonnull vc) {
            [weakSelf.navigationController presentViewController:vc animated:YES completion:nil];
        } alertPresenter:^(UIViewController * _Nonnull vc) {
            [weakSelf.navigationController presentViewController:vc animated:YES completion:nil];
        } pickerPresenter:^(UIViewController * _Nonnull vc) {
            [weakSelf.navigationController presentViewController:vc animated:YES completion:nil];
        }];
    };
    self.viewModel.didReceiveMessage = ^{
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:weakSelf.viewModel.messages.count - 1 inSection:0];
        [weakSelf.chatView.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [weakSelf.chatView scrollToBottomAnimated:YES];
        });
    };
    self.viewModel.didTakeNewPhoto = ^(UIImage * _Nonnull image) {
        [weakSelf.viewModel showPhotoCropControllerWithImage:image presenter:^(UIViewController * _Nonnull vc) {
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    };
}

- (void)navigation {
    self.title = _viewModel.conversation.name;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:0];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    UIButton *addParticipantButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [addParticipantButton setImage:[UIImage imageNamed:@"add"] forState:0];
    [addParticipantButton addTarget:self action:@selector(addParticipant) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *addParticipantBarButton = [[UIBarButtonItem alloc] initWithCustomView:addParticipantButton];
    
    self.navigationItem.rightBarButtonItem = addParticipantBarButton;
}

- (void)reload {
    [self.chatView.tableView reloadData];
}

- (void)addParticipant {
    CMPAddParticipantsViewModel *vm = [[CMPAddParticipantsViewModel alloc] initWithClient:_viewModel.client conversationID:_viewModel.conversation.id];
    CMPAddParticipantsViewController *vc = [[CMPAddParticipantsViewController alloc] initWithViewModel:vm];
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _viewModel.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMPMessage *msg = _viewModel.messages[indexPath.row];
    if (msg.parts.firstObject.url) {
        CMPChatImageMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];
        
        NSString *fromID = msg.context.from.id;
        NSString *selfID = _viewModel.client.profileID;
        
        BOOL isMine = [fromID isEqualToString:selfID];
        [cell configureWithMessage:msg ownership:isMine ? CMPMessageOwnershipSelf : CMPMessageOwnershipOther downloader:_viewModel.downloader animate:NO];

        return cell;
    } else {
        CMPChatTextMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        
        NSString *fromID = msg.context.from.id;
        NSString *selfID = _viewModel.client.profileID;
        BOOL isMine = [fromID isEqualToString:selfID];
        [cell configureWithMessage:msg ownership:isMine ? CMPMessageOwnershipSelf : CMPMessageOwnershipOther];
        
        return cell;
    }
}

@end
