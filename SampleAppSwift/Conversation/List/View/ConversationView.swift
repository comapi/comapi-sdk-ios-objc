//
//  ConversationView.swift
//  ComapiChatSDKTestApp
//
//  Created by Dominik Kowalski on 03/07/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class ConversationView: UIView {

    let tableView: UITableView
    
    init() {
        
        tableView = UITableView()
        
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        customize(self)
        customize(tableView)
        
        layout(tableView)
        
        constrain(tableView)
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
        default:
            break
        }
    }
    
    func layout(_ view: UIView) {
        switch view {
        case tableView:
            addSubview(tableView)
        default:
            break
        }
    }
    
    func constrain(_ view: UIView) {
        view.snp.remakeConstraints {
            switch view {
            case tableView:
                $0.edges.equalToSuperview()
            default:
                break
            }
        }
    }
}
