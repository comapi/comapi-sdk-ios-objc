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

#import "CMPAddParticipantsViewController.h"
#import "CMPMessageOwnership.h"
#import "CMPMessagePartCell.h"
#import "CMPAttachmentCell.h"

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create([@"queue" UTF8String], DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_async(queue, ^{
        dispatch_group_enter(group);
        [weakSelf.viewModel getMessagesWithCompletion:^(NSArray<CMPMessage *> * _Nullable messages, NSError * _Nullable error) {
            dispatch_group_leave(group);
        }];
        
        dispatch_group_enter(group);
        [weakSelf.viewModel getParticipantsWithCompletion:^(NSArray<CMPConversationParticipant *> * _Nullable participants, NSError * _Nullable error) {
            dispatch_group_leave(group);
        }];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [weakSelf reload:NO];
            [weakSelf scrollToLastIndex];
        });
    });
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unregisterFromKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewModel.shouldReloadAttachments();
}

- (void)delegates {
    self.chatView.tableView.delegate = self;
    self.chatView.tableView.dataSource = self;
    self.chatView.attachmentsView.collectionView.delegate = self;
    self.chatView.attachmentsView.collectionView.dataSource = self;
    
    __weak typeof(self) weakSelf = self;
    self.keyboardWillShow = ^(NSNotification * _Nonnull notif) {
        [weakSelf.chatView animateOnKeyboardChangeWithNotification:notif completion:nil];
    };
    self.keyboardWillHide = ^(NSNotification * _Nonnull notif) {
        [weakSelf.chatView animateOnKeyboardChangeWithNotification:notif completion:nil];
    };
    self.chatView.didTapSendButton = ^(NSString * _Nonnull text) {
        [weakSelf.chatView.inputMessageView endEditing];
        [weakSelf.viewModel sendMessage:[text isEqualToString:@""] ? nil : text completion:^(NSError * _Nullable error) {
            weakSelf.viewModel.shouldReloadAttachments();
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
    self.viewModel.didDeleteParticipant = ^(NSString * _Nonnull pid) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Participant deleted." message:[NSString stringWithFormat:@"Participant with id - %@ was deleted", pid] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        
        [alert addAction:dismissAction];
    };
    self.viewModel.didDeleteConversation = ^(NSString * _Nonnull cid) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Conversation deleted." message:[NSString stringWithFormat:@"Conversation with id - %@ was deleted", cid] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        
        [alert addAction:dismissAction];
    };
    self.viewModel.shouldReloadMessageAtIndex = ^(NSInteger idx) {
        if (idx > weakSelf.viewModel.messages.count - 1 || idx < 0) {
            return;
        }
        
        NSArray *indices = @[[NSIndexPath indexPathForRow:idx inSection:0]];
        [UIView performWithoutAnimation:^{
            CGPoint loc = weakSelf.chatView.tableView.contentOffset;
            [weakSelf.chatView.tableView reloadRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationNone];
            weakSelf.chatView.tableView.contentOffset = loc;
        }];
    };
    self.viewModel.shouldReloadMessages = ^(BOOL showNewMessage) {
        if (!showNewMessage) {
            [weakSelf reload:NO];
            [weakSelf scrollToLastIndex];
        } else {
            [weakSelf reload:YES];
        }
    };
    self.viewModel.didTakeNewPhoto = ^(UIImage * _Nonnull image) {
        [weakSelf.viewModel showPhotoCropControllerWithImage:image presenter:^(UIViewController * _Nonnull vc) {
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    };
    self.chatView.didTapNewMessageButton = ^{
        [weakSelf scrollToLastIndex];
        [weakSelf.chatView showNewMessageView:NO completion:nil];
    };
    
    self.viewModel.shouldReloadAttachments = ^{
        if (weakSelf.viewModel.imageAttachments.count > 0) {
            [weakSelf.chatView showAttachmentsWithCompletion:^{
                [weakSelf.chatView reloadAttachments];
                [weakSelf.chatView adjustTableViewContentInset];
            }];
        } else if (weakSelf.viewModel.imageAttachments.count == 0) {
            [weakSelf.chatView hideAttachmentsWithCompletion:^{
                [weakSelf.chatView reloadAttachments];
                [weakSelf.chatView adjustTableViewContentInset];
            }];
        }
        [weakSelf.chatView updateSendButtonState];
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

- (void)reload:(BOOL)showNewMessageView {
    [self.chatView.tableView reloadData];
    if (showNewMessageView) {
        if (self.chatView.tableView.contentOffset.y < self.chatView.tableView.contentSize.height) {
            [self.chatView showNewMessageView:YES completion:nil];
        }
    }
}

- (void)scrollToLastIndex {
    if (self.viewModel.messages.count == 0) {
        return;
    }

    NSInteger lastIndex = self.viewModel.messages.count - 1;
    [self.chatView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
    CMPMessagePartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *fromID = msg.context.from.id;
    NSString *selfID = _viewModel.client.profileID;
    BOOL isMine = [fromID isEqualToString:selfID];
    
    [cell configureWithMessage:msg participants:_viewModel.participants ownership:isMine ? CMPMessageOwnershipSelf : CMPMessageOwnershipOther downloader:_viewModel.downloader];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.imageAttachments.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CMPAttachmentCell *cell = (CMPAttachmentCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell configureWithImage:self.viewModel.imageAttachments[indexPath.row]];
    cell.didTapDelete = ^{
        [self.viewModel.imageAttachments removeObjectAtIndex:indexPath.row];
        self.viewModel.shouldReloadAttachments();
    };
    return cell;
}

@end
