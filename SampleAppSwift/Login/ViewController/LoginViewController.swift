//
//  LoginViewController.swift
//  SampleApp
//
//  Created by Dominik Kowalski on 10/08/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    var loginView: LoginView { return view as! LoginView }
    
    let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        
        super.init()
        
        delegates()
        navigation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = LoginView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
        registerForLoadingNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterFromKeyboardNotifications()
        unregisterFromLoadingNotification()
    }
    
    override func delegates() {
        loginView.tableView.delegate = self
        loginView.tableView.dataSource = self
        
        loginView.didTapLoginButton = {
            self.viewModel.configure(completion: { [weak self] (error) in
                guard let `self` = self else { return }
                if error != nil {
                    let alert = UIAlertController(title: "Login info error", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.navigationController?.present(alert, animated: true, completion: nil)
                } else {
                    let vm = ConversationViewModel(client: self.viewModel.client)
                    let vc = ConversationViewController(viewModel: vm)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }
        
        keyboardWillShow = { [weak self] notification in
            self?.loginView.animateOnKeyboardChange(notification: notification, completion: nil)
        }
        
        keyboardWillHide = { [weak self] notification in
            self?.loginView.animateOnKeyboardChange(notification: notification, completion: nil)
        }
        
        loadingWillPerform = { [weak self] notif in
            self?.showLoader()
        }
        
        loadingWillStop = { [weak self] notif in
            self?.hideLoader()
        }
    }
    
    override func navigation() {
        navigationItem.title = "Login"
    }
    
    func reload() {
        loginView.tableView.reloadData()
    }
}

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TitledInputCell {
            switch indexPath.row {
            case 0:
                cell.configure(with: "Api-Space-ID", value: viewModel.loginInfo.apiSpaceId ?? "")
                cell.didChangeText = { text in
                    self.viewModel.loginInfo.apiSpaceId = text
                }
            case 1:
                cell.configure(with: "Profile-ID", value: viewModel.loginInfo.profileId ?? "")
                cell.didChangeText = { text in
                    self.viewModel.loginInfo.profileId = text
                }
            case 2:
                cell.configure(with: "Issuer", value: viewModel.loginInfo.issuer ?? "")
                cell.didChangeText = { text in
                    self.viewModel.loginInfo.issuer = text
                }
            case 3:
                cell.configure(with: "Audience", value: viewModel.loginInfo.audience ?? "")
                cell.didChangeText = { text in
                    self.viewModel.loginInfo.audience = text
                }
            case 4:
                cell.configure(with: "Secret", value: viewModel.loginInfo.secret ?? "")
                cell.didChangeText = { text in
                    self.viewModel.loginInfo.secret = text
                }
            default:
                break
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}
