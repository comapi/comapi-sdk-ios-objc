//
//  InsetTextField.swift
//  ComapiChatSDKTestApp
//
//  Created by Dominik Kowalski on 03/07/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class InsetTextField: UITextField {
    
    var didChangeText: ((String) -> ())?
    
    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }
    
    func configure() {
        keyboardAppearance = .dark
        layer.cornerRadius = 4
        backgroundColor = .clear
        textColor = .white
        font = UIFont.systemFont(ofSize: 16)
        addTarget(self, action: #selector(textChanged), for: .editingChanged)
        inputAccessoryView = UIToolbar.toolbar(title: "Done", target: self, action: #selector(dismiss))
    }
    
    @objc func textChanged() {
        didChangeText?(text ?? "")
    }
    
    @objc func dismiss() {
        resignFirstResponder()
    }
}
