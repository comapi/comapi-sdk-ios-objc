//
//  TitledInputCell.swift
//  SampleApp
//
//  Created by Dominik Kowalski on 10/08/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit
import SnapKit

class TitledInputCell: BaseTableViewCell {

    let titledTextField: TitledTextField
    
    var didChangeText: ((String) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        titledTextField = TitledTextField()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        customize(self)
        customize(titledTextField)
        
        layout(titledTextField)
        
        constrain(titledTextField)
    }
    
    func customize(_ view: UIView) {
        switch view {
        case self:
            selectionStyle = .none
            contentView.backgroundColor = .gray
        case titledTextField:
            titledTextField.didChangeText = { [weak self] text in
                self?.didChangeText?(text)
            }
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
        view.snp.remakeConstraints {
            switch view {
            case titledTextField:
                $0.top.equalToSuperview().offset(8)
                $0.bottom.equalToSuperview().offset(-8)
                $0.trailing.equalToSuperview().offset(-8)
                $0.leading.equalToSuperview().offset(8)
            default:
                break
            }
        }
    }
    
    func configure(with title: String, value: String?) {
        titledTextField.setup(with: title, value: value)
    }
}
