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

class ConversationView: UIView {

    let tableView: UITableView
    let containerView: UIView
    let notificationSwitch: UISwitch
    let label: UILabel
    
    var didChangeSwitchValue: (() -> ())?
    
    init() {
        
        tableView = UITableView()
        containerView = UIView()
        notificationSwitch = UISwitch()
        label = UILabel()
        
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        customize(self)
        customize(tableView)
        customize(containerView)
        customize(label)
        customize(notificationSwitch)
        
        layout(tableView)
        layout(containerView)
        layout(label)
        layout(notificationSwitch)
        
        constrain(tableView)
        constrain(containerView)
        constrain(label)
        constrain(notificationSwitch)
    }
    
    func customize(_ view: UIView) {
        switch view {
        case self:
            backgroundColor = .clear
        case tableView:
            tableView.backgroundColor = .gray
            tableView.separatorStyle = .none
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 44
            tableView.register(ConversationCell.self, forCellReuseIdentifier: "conversationCell")
        case containerView:
            containerView.backgroundColor = .gray
            containerView.layer.borderColor = UIColor.white.cgColor
            containerView.layer.borderWidth = 1.0
        case notificationSwitch:
            notificationSwitch.setOn(false, animated: false)
            notificationSwitch.onTintColor = .black
            notificationSwitch.tintColor = .white
            notificationSwitch.isEnabled = false
            notificationSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        case label:
            label.text = "Notification status"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 16)
        default:
            break
        }
    }
    
    func layout(_ view: UIView) {
        switch view {
        case tableView:
            addSubview(tableView)
        case containerView:
            addSubview(containerView)
        case label:
            containerView.addSubview(label)
        case notificationSwitch:
            containerView.addSubview(notificationSwitch)
        default:
            break
        }
    }
    
    func constrain(_ view: UIView) {
        view.snp.remakeConstraints {
            switch view {
            case tableView:
                $0.edges.equalToSuperview()
            case containerView:
                if #available(iOS 11.0, *) {
                    $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
                } else {
                    $0.bottom.equalToSuperview()
                }                
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview()
            case label:
                $0.height.greaterThanOrEqualTo(44)
                $0.top.equalToSuperview().offset(8)
                $0.bottom.equalToSuperview().offset(-8)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalTo(notificationSwitch.snp.leading).offset(-16)
            case notificationSwitch:
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().offset(-16)
            default:
                break
            }
        }
    }
    
    @objc func switchValueChanged() {
        self.didChangeSwitchValue?()
    }
}
