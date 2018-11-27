//
//  SeparatorCell.swift
//  ComapiChatSDKTestApp
//
//  Created by Dominik Kowalski on 03/07/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class SeparatorCell: UITableViewCell {
    
    let topSeparator: Separator
    let bottomSeparator: Separator
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        topSeparator = Separator(color: .white)
        bottomSeparator = Separator(color: .white)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        customize(self)
        
        layout(topSeparator)
        layout(bottomSeparator)
        
        constrain(topSeparator)
        constrain(bottomSeparator)
    }
    
    func customize(_ view: UIView) {
        switch view {
        case self:
            selectionStyle = .none
            backgroundColor = .clear
            contentView.backgroundColor = .clear
        default:
            break
        }
    }
    
    func layout(_ view: UIView) {
        switch view {
        default:
            contentView.addSubview(view)
        }
    }
    
    func constrain(_ view: UIView) {
        view.snp.makeConstraints {
            switch view {
            case topSeparator:
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview().offset(8)
                $0.trailing.equalToSuperview().offset(-8)
                $0.height.equalTo(1)
            case bottomSeparator:
                $0.bottom.equalToSuperview()
                $0.leading.equalToSuperview().offset(8)
                $0.trailing.equalToSuperview().offset(-8)
                $0.height.equalTo(1)
            default:
                break
            }
        }
    }
    
    func configure(topSeparator topVisible: Bool, bottomSeparator bottomVisible: Bool) {
        topSeparator.isHidden = !topVisible
        bottomSeparator.isHidden = !bottomVisible
    }
    
}
