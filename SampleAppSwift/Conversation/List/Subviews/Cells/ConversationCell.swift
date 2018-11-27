//
//  ConversationCell.swift
//  ComapiChatSDKTestApp
//
//  Created by Dominik Kowalski on 03/07/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit
import CMPComapiFoundation

class ConversationCell: SeparatorCell {
    
    let dateLabel: UILabel
    let nameLabel: UILabel

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        dateLabel = UILabel()
        nameLabel = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        customize(self)
        customize(dateLabel)
        customize(nameLabel)
        
        layout(dateLabel)
        layout(nameLabel)
        
        constrain(dateLabel)
        constrain(nameLabel)
    }
    
    override func customize(_ view: UIView) {
        super.customize(view)
        switch view {
        case self:
            selectionStyle = .none
            backgroundColor = .clear
            contentView.backgroundColor = .clear
        case nameLabel:
            nameLabel.textColor = .white
            nameLabel.textAlignment = .left
            nameLabel.font = UIFont.systemFont(ofSize: 18)
            nameLabel.numberOfLines = 0
        case dateLabel:
            dateLabel.textColor = .white
            dateLabel.textAlignment = .left
            dateLabel.font = UIFont.systemFont(ofSize: 14)
            dateLabel.numberOfLines = 0
        default:
            break
        }
    }
    
    override func layout(_ view: UIView) {
        super.layout(view)
        switch view {
        case nameLabel, dateLabel:
            contentView.addSubview(view)
        default:
            break
        }
    }
    
    override func constrain(_ view: UIView) {
        super.constrain(view)
        view.snp.makeConstraints {
            switch view {
            case nameLabel:
                $0.height.greaterThanOrEqualTo(24)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                $0.bottom.equalToSuperview().offset(-8)
            case dateLabel:
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                $0.bottom.equalTo(nameLabel.snp.top).offset(-8)
                $0.top.equalToSuperview().offset(8)
            default:
                break
            }
        }
    }
    
    func configure(with conversation: Conversation, bottomSeparator: Bool = false, topSeparator: Bool = false) {
        nameLabel.text = conversation.name
        configure(topSeparator: topSeparator, bottomSeparator: bottomSeparator)
    }

}
