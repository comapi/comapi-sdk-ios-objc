//
//  CMPChatViewController.m
//  SampleApp
//
//  Created by Dominik Kowalski on 15/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPChatViewController.h"
#import "CMPChatTextMessageCell.h"

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
}

- (void)reload {
    [self.chatView.tableView reloadData];
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

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.messages.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let msg = viewModel.messages[indexPath.row]
//
//        if let _ = msg.parts?.first?.url {
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? ChatImageMessageCell {
//
//                if let fromID = msg.context?.from?.id, let profileID = viewModel.client.profileId {
//                    let isMine = fromID == profileID
//                    if indexPath.row == viewModel.messages.count - 1 {
//                        cell.configure(with: viewModel.messages[indexPath.row], state: isMine ? .me : .other, downloader: viewModel.downloader, statusViewHidden: false)
//                    } else {
//                        cell.configure(with: viewModel.messages[indexPath.row], state: isMine ? .me : .other, downloader: viewModel.downloader)
//                    }
//                }
//
//                return cell
//            }
//        } else {
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as? ChatTextMessageCell {
//                let msg = viewModel.messages[indexPath.row]
//
//
//                return cell
//            }
//        }
//
//        return UITableViewCell()
//        }
//        }


@end

////
////  ChatViewController.swift
////  ComapiChatSDKTestApp
////
////  Created by Dominik Kowalski on 02/07/2018.
////  Copyright © 2018 Dominik Kowalski. All rights reserved.
////
//
//import UIKit
//
//class ChatViewController: BaseViewController {
//
//    var chatView: ChatView { return view as! ChatView }
//
//    let viewModel: ChatViewModel
//
//    init(viewModel: ChatViewModel) {
//
//        self.viewModel = viewModel
//
//        super.init()
//
//        navigation()
//        delegates()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func loadView() {
//        view = ChatView()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        registerForKeyboardNotifications()
//        registerForLoadingNotification()
//
//        viewModel.queryEvents(success: { [weak self] in
//            self?.viewModel.getMessages(success: { [weak self] in
//                self?.reload()
//            }) { (error) in
//                print(error)
//            }
//        }) { (error) in
//            print(error)
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        unregisterFromKeyboardNotifications()
//        unregisterFromLoadingNotification()
//    }
//
//    override func delegates() {

//    }
//
//    override func navigation() {
//        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
//        backButton.setImage(UIImage(named: "back"), for: UIControlState())
//        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
//
//        let backBarButton = UIBarButtonItem(customView: backButton)
//
//        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
//        rightButton.setImage(UIImage(named: "add"), for: UIControlState())
//        rightButton.addTarget(self, action: #selector(addParticipant), for: .touchUpInside)
//
//        let rightBarButton = UIBarButtonItem(customView: rightButton)
//
//        navigationItem.rightBarButtonItem = rightBarButton
//        navigationItem.leftBarButtonItem = backBarButton
//        navigationItem.title = viewModel.conversation.name
//    }
//
//    func reload() {
//        chatView.tableView.reloadData()
//    }
//
//    @objc func addParticipant() {
//        let vm = AddParticipantViewModel(client: viewModel.client, conversationId: viewModel.conversation.id)
//        let vc = AddParticipantViewController(viewModel: vm)
//        present(vc, animated: true, completion: nil)
//    }
//}
//
//extension ChatViewController: UITableViewDelegate, UITableViewDataSource {

