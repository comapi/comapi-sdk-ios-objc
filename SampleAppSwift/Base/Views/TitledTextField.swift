//
//  TitledTextField.swift
//  SampleApp
//
//  Created by Dominik Kowalski on 10/08/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit
import SnapKit

class TitledTextField: BaseView {
    
    var titleLabel: UILabel
    var textField: InsetTextField
    
    var didChangeText: ((String) -> ())?
    
    override init() {
        titleLabel = UILabel()
        textField = InsetTextField()
        
        super.init()
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        customize(self)
        customize(titleLabel)
        customize(textField)
        
        layout(titleLabel)
        layout(textField)
        
        constrain(titleLabel)
        constrain(textField)
    }
    
    func customize(_ view: UIView) {
        switch view {
        case self:
            backgroundColor = .clear
        case titleLabel:
            titleLabel.backgroundColor = .clear
            titleLabel.font = UIFont.systemFont(ofSize: 16)
            titleLabel.textColor = .white
            titleLabel.numberOfLines = 0
        case textField:
            textField.backgroundColor = .clear
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.white.cgColor
            textField.didChangeText = { [weak self] text in
                self?.didChangeText?(text)
            }
        default:
            break
        }
    }
    
    func layout(_ view: UIView) {
        switch view {
        default:
            addSubview(view)
        }
    }
    
    func constrain(_ view: UIView) {
        view.snp.remakeConstraints {
            switch view {
            case titleLabel:
                $0.top.trailing.leading.equalToSuperview()
            case textField:
                $0.top.equalTo(titleLabel.snp.bottom).offset(8)
                $0.bottom.trailing.leading.equalToSuperview()
                $0.height.greaterThanOrEqualTo(40)
            default:
                break
            }
        }
    }
    
    func clear() {
        textField.text = ""
    }
    
    func setup(with title: String, value: String? = nil) {
        titleLabel.text = title
        textField.text = value ?? ""
        
    }
    
    func editingEnabled(_ enabled: Bool) {
        textField.isEnabled = enabled
    }
    
    @objc func textChanged() {
        didChangeText?(textField.text ?? "")
    }
    
    @objc func dismiss() {
        textField.resignFirstResponder()
    }
}

