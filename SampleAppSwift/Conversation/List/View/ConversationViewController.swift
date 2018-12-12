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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForLoadingNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationValueChanged), name: Notification.Name(rawValue: PushRegistrationStatusChangedNotification), object: nil)
        viewModel.getAllConverstations(success: { [weak self] in
            self?.reload()
            self?.viewModel.registerForRemoteNotification(completion: { (success, error) in
                if error == nil && success {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            })
        }) { error in
            print(error ?? "")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterFromLoadingNotification()
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: PushRegistrationStatusChangedNotification), object: nil)
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
    
    func openChatController(for conversation: Conversation) {
        let vm = ChatViewModel(client: viewModel.client, conversation: conversation)
        let vc = ChatViewController(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addTapped() {
        let vm = CreateConversationViewModel(client: viewModel.client)
        let vc = CreateConversationViewController(viewModel: vm)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func refreshTapped() {
        viewModel.getAllConverstations(success: { [weak self] in
            self?.reload()
        }) { error in
            print(error ?? "")
        }
    }
    
    @objc func notificationValueChanged(notification: Notification) {
        if let val = notification.object as? Bool {
            self.conversationView.notificationSwitch.setOn(val, animated: true)
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
            let conversation = viewModel.conversations[indexPath.row]
            openChatController(for: conversation)
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
