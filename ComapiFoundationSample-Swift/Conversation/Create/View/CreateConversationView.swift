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

class CreateConversationView: BaseView {
    
    let container: UIView
    let closeButton: UIButton
    let tableView: UITableView
    let createButton: UIButton
    
    var didTapClose: (() -> ())?
    var didTapCreate: (() -> ())?
    
    override init() {
        closeButton = UIButton()
        container = UIView()
        tableView = UITableView()
        createButton = UIButton()
        
        super.init()
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        customize(closeButton)
        customize(tableView)
        customize(container)
        customize(createButton)
        
        layout(closeButton)
        layout(tableView)
        layout(container)
        layout(createButton)
        
        constrain(closeButton)
        constrain(tableView)
        constrain(container)
        constrain(createButton)
    }
    
    func customize(_ view: UIView) {
        switch view {
        case self:
            isUserInteractionEnabled = true
            backgroundColor = .clear
        case tableView:
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 44
            tableView.register(TitleInputCell.self, forCellReuseIdentifier: "inputCell")
        case closeButton:
            closeButton.setImage(UIImage(named: "close"), for: UIControl.State())
            closeButton.setTitleColor(UIColor.white, for: UIControl.State())
            closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        case container:
            container.backgroundColor = .gray
            container.layer.borderColor = UIColor.white.cgColor
            container.layer.borderWidth = 1
            container.layer.cornerRadius = 8
            container.layer.shadowColor = UIColor.black.cgColor
            container.layer.shadowRadius = 4.0
            container.layer.shadowOpacity = 0.6
            container.layer.shadowOffset = CGSize(width: 0, height: 4)
        case createButton:
            createButton.setTitle("Create", for: UIControl.State())
            createButton.setTitleColor(UIColor.white, for: UIControl.State())
            createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
            
        default:
            break
        }
    }
    
    func layout(_ view: UIView) {
        switch view {
        case closeButton:
            container.addSubview(closeButton)
        case container:
            addSubview(container)
        case createButton:
            container.addSubview(createButton)
        case tableView:
            container.addSubview(tableView)
        default:
            break
        }
    }
    
    func constrain(_ view: UIView) {
        view.snp.remakeConstraints {
            switch view {
            case closeButton:
                $0.top.leading.equalToSuperview().offset(16)
                $0.size.equalTo(36)
            case container:
                $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 100, left: 16, bottom: 100, right: 16))
            case tableView:
                $0.top.equalTo(closeButton.snp.bottom).offset(16)
                $0.bottom.equalToSuperview()
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
            case createButton:
                $0.leading.equalToSuperview().offset(32)
                $0.trailing.equalToSuperview().offset(-32)
                $0.bottom.equalToSuperview().offset(-8)
                $0.height.equalTo(40)
            default:
                break
            }
        }
    }
    
    @objc func closeTapped() {
        didTapClose?()
    }
    
    @objc func createTapped() {
        didTapCreate?()
    }
}
