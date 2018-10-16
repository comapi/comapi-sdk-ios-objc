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

//var conversationView: CreateConversationView { return view as! CreateConversationView }
//
//let viewModel: CreateConversationViewModel
//
//init(viewModel: CreateConversationViewModel) {
//
//    self.viewModel = viewModel
//
//    super.init()
//
//    navigation()
//    delegates()
//}
//
//required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//}
//
//override func loadView() {
//    view = CreateConversationView()
//}
//
//override func viewDidLoad() {
//    super.viewDidLoad()
//    viewModel.getProfiles(success: { [weak self] (profiles) in
//        self?.reload()
//    }) { (error) in
//        print(error)
//    }
//}
//
//override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    registerForLoadingNotification()
//}
//
//override func viewWillDisappear(_ animated: Bool) {
//    super.viewWillDisappear(animated)
//    unregisterFromLoadingNotification()
//}
//
//override func navigation() {
//    modalTransitionStyle = .crossDissolve
//    modalPresentationStyle = .overCurrentContext
//}
//
//override func delegates() {
//    conversationView.tableView.delegate = self
//    conversationView.tableView.dataSource = self
//
//    conversationView.didTapClose = { [weak self] in
//        self?.dismiss(animated: true, completion: nil)
//    }
//
//    conversationView.didTapCreate = { [weak self] in
//        guard let `self` = self else { return }
//        self.viewModel.createConversation(isPublic: false, success: { (alreadyExists, conversation) in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
//                self.dismiss(animated: true) {
//                    if let nav = self.presentingViewController as? UINavigationController, let vc = nav.viewControllers.first(where: { $0 is ConversationViewController }) as? ConversationViewController {
//                        vc.viewModel.getAllConverstations(success: { [weak self] in
//                            self?.reload()
//                        }) { error in
//                            print(error)
//                        }
//                    }
//                }
//            })
//        }, failure: { error in
//            print(error)
//        })
//    }
//}
//
//func reload() {
//    conversationView.tableView.reloadData()
//}
//
//func reload(row: Int) {
//    conversationView.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
//}
//}
//
//extension CreateConversationViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.row {
//        case 0:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as? TitleInputCell {
//                cell.setup(inputType: .keyboard, with: "Name", value: "", topSeparator: false, bottomSeparator: true)
//                cell.didChangeText = { [weak self] text in
//                    self?.viewModel.newConversation.name = text
//                }
//                return cell
//            }
//        case 1:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as? TitleInputCell {
//                cell.setup(inputType: .keyboard, with: "Description", value: "", topSeparator: false, bottomSeparator: true)
//                cell.didChangeText = { [weak self] text in
//                    self?.viewModel.newConversation.conversationDescription = text
//                }
//                return cell
//            }
//        default:
//            break
//        }
//        return UITableViewCell()
//    }
//}
