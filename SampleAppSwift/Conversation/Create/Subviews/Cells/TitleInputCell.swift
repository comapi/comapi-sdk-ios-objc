//
//  TitleInputCell.swift
//  ComapiChatSDKTestApp
//
//  Created by Dominik Kowalski on 03/07/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class TitleInputCell: SeparatorCell {
    
    enum InputType {
        case picker
        case keyboard
    }
    
    var titleLabel: UILabel
    var textField: InsetTextField
    var pickerView: UIPickerView!
    
    var didChangeText: ((String) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        titleLabel = UILabel()
        textField = InsetTextField()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        
        customize(self)
        customize(titleLabel)
        customize(textField)
        
        layout(titleLabel)
        layout(textField)
        
        constrain(titleLabel)
        constrain(textField)
    }
    
    override func customize(_ view: UIView) {
        super.customize(view)
        switch view {
        case self:
            backgroundColor = .clear
            contentView.backgroundColor = .clear
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
    
    override func layout(_ view: UIView) {
        super.layout(view)
        switch view {
        default:
            addSubview(view)
        }
    }
    
    override func constrain(_ view: UIView) {
        super.constrain(view)
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
    
    func setup(inputType: InputType, with title: String, value: String? = nil, topSeparator: Bool = false, bottomSeparator: Bool = false) {
        titleLabel.text = title
        textField.text = value ?? ""
        configure(topSeparator: topSeparator, bottomSeparator: bottomSeparator)
        if inputType == .picker {
            pickerView = UIPickerView()
            textField.inputView = pickerView
        } else {
            textField.inputView = nil
        }
    }
    
    func picker(delegate: UIPickerViewDataSource & UIPickerViewDelegate) {
        if pickerView != nil {
            pickerView.dataSource = delegate
            pickerView.delegate = delegate
        }
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
