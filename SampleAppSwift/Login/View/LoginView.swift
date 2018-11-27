//
//  LoginView.swift
//  SampleApp
//
//  Created by Dominik Kowalski on 10/08/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class LoginView: BaseView {
    
    let tableView: UITableView
    let loginButton: GrayButtonWithWhiteText
    
    var didTapLoginButton: (() -> ())?
    
    override init() {
        tableView = UITableView()
        loginButton = GrayButtonWithWhiteText()
        
        super.init()
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        customize(self)
        customize(tableView)
        customize(loginButton)
        
        layout(tableView)
        layout(loginButton)
        
        constrain(tableView)
        constrain(loginButton)
    }
    
    func customize(_ view: UIView) {
        switch view {
        case self:
            backgroundColor = .gray
        case tableView:
            tableView.keyboardDismissMode = .onDrag
            tableView.backgroundColor = .gray
            tableView.separatorStyle = .none
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 44
            tableView.register(TitledInputCell.self, forCellReuseIdentifier: "cell")
        case loginButton:
            loginButton.setTitle("Login", for: UIControl.State())
            loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        default:
            break
        }
    }
    
    func layout(_ view: UIView) {
        switch view {
        case tableView, loginButton:
            addSubview(view)
        default:
            break
        }
    }
    
    func constrain(_ view: UIView) {
        view.snp.remakeConstraints {
            switch view {
            case tableView:
                $0.edges.equalToSuperview()
            case loginButton:
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                $0.bottom.equalToSuperview().offset(-16)
                $0.height.equalTo(44)
            default:
                break
            }
        }
    }
    
    @objc func loginTapped() {
        didTapLoginButton?()
    }
    
    func animateOnKeyboardChange(notification: Notification, completion: (() -> ())?) {
        guard let info = notification.userInfo else { return }
        let name = notification.name
        let curve = UIView.AnimationCurve(rawValue: (info[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)!
        let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let endFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [UIView.AnimationOptions(rawValue: UInt(curve.rawValue))], animations: {
            if name == UIResponder.keyboardWillShowNotification {
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: endFrame.height + 16, right: 0)
            } else {
                self.tableView.contentInset = .zero
            }
            self.layoutIfNeeded()
        }) { _ in
            completion?()
        }
    }
}

