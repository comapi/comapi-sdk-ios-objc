//
//  ConversationViewController.swift
//  ComapiChatSDKTestApp
//
//  Created by Dominik Kowalski on 03/07/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit
import CMPComapiFoundation

class ConversationViewController: BaseViewController {

    var conversationView: ConversationView { return view as! ConversationView }
    
    let viewModel: ConversationViewModel
    
    init(viewModel: ConversationViewModel) {
        self.viewModel = viewModel
        
        super.init()
        
        navigation()
        delegates()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ConversationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getAllConverstations(success: { [weak self] in
            self?.reload()
        }) { error in
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
        let addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        addButton.setImage(UIImage(named: "add"), for: UIControl.State())
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        let logoutButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        logoutButton.setImage(UIImage(named: "back"), for: UIControl.State())
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        
        let addBarButton = UIBarButtonItem(customView: addButton)
        let logoutBarButton = UIBarButtonItem(customView: logoutButton)
        
        navigationItem.leftBarButtonItem = logoutBarButton
        navigationItem.rightBarButtonItem = addBarButton
        navigationItem.title = "Conversations"
    }

    override func delegates() {
        conversationView.tableView.delegate = self
        conversationView.tableView.dataSource = self
        
        loadingWillPerform = { [weak self] notif in
            self?.showLoader()
        }
        
        loadingWillStop = { [weak self] notif in
            self?.hideLoader()
        }
    }
    
    func reload() {
        conversationView.tableView.reloadData()
    }
    
//    func openChatController(for conversation: Conversation) {
//        let vm = ChatViewModel(client: viewModel.client, conversation: conversation)
//        let vc = ChatViewController(viewModel: vm)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    @objc func addTapped() {
        let vm = CreateConversationViewModel(client: viewModel.client)
        let vc = CreateConversationViewController(viewModel: vm)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func refreshTapped() {
        viewModel.getAllConverstations(success: { [weak self] in
            self?.reload()
        }) { error in
            print(error)
        }
    }
    
    @objc func logoutTapped() {
       (UIApplication.shared.delegate as! AppDelegate).configurator.restart()
    }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as? ConversationCell {
            cell.configure(with: viewModel.conversations[indexPath.row], bottomSeparator: true, topSeparator: false)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) as? ConversationCell {
           // let conversation = viewModel.conversations[indexPath.row]
            //openChatController(for: conversation)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let conversation = viewModel.conversations[indexPath.row]
            viewModel.deleteConversation(for: conversation.id, success: { [weak self] (success) in
                self?.viewModel.getAllConverstations(success: {
                    self?.reload()
                }, failure: { (error) in
                    self?.reload()
                })
            }) { [weak self] (error) in
                self?.reload()
            }
        }
    }

}
