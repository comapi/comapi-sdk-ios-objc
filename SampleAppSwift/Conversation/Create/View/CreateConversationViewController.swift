//
//  CreateConversationViewController.swift
//  ComapiChatSDKTestApp
//
//  Created by Dominik Kowalski on 03/07/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit
import CMPComapiFoundation

class CreateConversationViewController: BaseViewController {

    var conversationView: CreateConversationView { return view as! CreateConversationView }
    
    let viewModel: CreateConversationViewModel
    
    init(viewModel: CreateConversationViewModel) {
        
        self.viewModel = viewModel
        
        super.init()
        
        navigation()
        delegates()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = CreateConversationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getProfiles(success: { [weak self] (profiles) in
            self?.reload()
        }) { (error) in
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForLoadingNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterFromLoadingNotification()
    }

    override func navigation() {
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    override func delegates() {
        conversationView.tableView.delegate = self
        conversationView.tableView.dataSource = self
        
        conversationView.didTapClose = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        
        conversationView.didTapCreate = { [weak self] in
            guard let `self` = self else { return }
            self.viewModel.createConversation(isPublic: false, success: { (alreadyExists, conversation) in
                let nav = self.presentingViewController as! UINavigationController
                self.dismiss(animated: true) {
                    if let vc = nav.viewControllers.first(where: { $0 is ConversationViewController }) as? ConversationViewController {
                        vc.viewModel.getAllConverstations(success: { [weak self] in
                            vc.reload()
                        }) { error in
                            print(error)
                        }
                    }
                }
            }, failure: { error in
                print(error)
            })
        }
    }
    
    func reload() {
        conversationView.tableView.reloadData()
    }
    
    func reload(row: Int) {
        conversationView.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
}

extension CreateConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as? TitleInputCell {
                cell.setup(inputType: .keyboard, with: "Name", value: "", topSeparator: false, bottomSeparator: true)
                cell.didChangeText = { [weak self] text in
                    self?.viewModel.newConversation.name = text
                }
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as? TitleInputCell {
                cell.setup(inputType: .keyboard, with: "Description", value: "", topSeparator: false, bottomSeparator: true)
                cell.didChangeText = { [weak self] text in
                    self?.viewModel.newConversation.conversationDescription = text
                }
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
}
