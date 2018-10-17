//
//  CMPChatViewController.m
//  SampleApp
//
//  Created by Dominik Kowalski on 15/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPChatViewController.h"
#import "CMPChatTextMessageCell.h"
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
    self.viewModel.didReceiveMessage = ^{
        [weakSelf reload];
    };
    //
    //        keyboardWillShow = { [weak self] notification in
    //            self?.chatView.animateOnKeyboardChange(notification: notification, completion: nil)
    //        }
    //
    //        keyboardWillHide = { [weak self] notification in
    //            self?.chatView.animateOnKeyboardChange(notification: notification, completion: nil)
    //        }
    //
    //        loadingWillPerform = { [weak self] notif in
    //            self?.showLoader()
    //        }
    //
    //        loadingWillStop = { [weak self] notif in
    //            self?.hideLoader()
    //        }
    //
    //        chatView.didTapSendButton = { [weak self] text in
    //            self?.viewModel.sendText(message: text, success: {
    //                self?.reload()
    //            }, failure: { error in
    //                self?.reload()
    //            })
    //        }
    //
    //        chatView.didTapUploadButton = { [weak self] in
    //            self?.viewModel.showPhotoSourceActionSheetController(presenter: { (vc) in
    //                self?.navigationController?.present(vc, animated: true, completion: nil)
    //            }, alertPresenter: { (vc) in
    //                self?.navigationController?.present(vc, animated: true, completion: nil)
    //            }, pickerPresenter: { (vc) in
    //                self?.navigationController?.present(vc, animated: true, completion: nil)
    //            })
    //        }
    //
    //        viewModel.didTakeNewPhoto = { [weak self] image in
    //            self?.viewModel.showPhotoCropController(image: image, presenter: { (vc) in
    //                self?.navigationController?.pushViewController(vc, animated: true)
    //            })
    //        }
    //
    //        viewModel.didReceiveMessage = { [weak self] in
    //            self?.reload()
    //        }
    //
    //        viewModel.didReadMessage = { [weak self] messageRead in
    //
    //        }
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
        return [UITableViewCell new];
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
