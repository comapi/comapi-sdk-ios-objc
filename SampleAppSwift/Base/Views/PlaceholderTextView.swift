//
//  PlaceholderTextView.swift
//  ComapiChatSDKTestApp
//
//  Created by Dominik Kowalski on 04/07/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class PlaceholderTextView: UITextView {
    
    var placeholderLabel: UILabel!
    
    var didBeginEditing: ((UITextView) -> ())?
    var didEndEditing: ((UITextView) -> ())?
    var didChangeText: ((UITextView) -> ())?
    var didReturnTap: ((UITextView) -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        customize()
    }
    
    func customize() {
        delegate = self
        keyboardAppearance = .dark
        textColor = .white
        textContainerInset = UIEdgeInsets(top: 10, left: 6, bottom: 0, right: 10)
        backgroundColor = .clear
        font = UIFont.systemFont(ofSize: 14)
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        inputAccessoryView = UIToolbar.toolbar(title: "Dismiss", target: self, action: #selector(dismiss))
        
        placeholderLabel = UILabel()
        placeholderLabel.font = UIFont.systemFont(ofSize: 14)
        placeholderLabel.numberOfLines = 0
        placeholderLabel.textColor = .white
        
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func setPlaceholder(text: String) {
        placeholderLabel.text = text
    }
    
    func clearInput() {
        text = ""
        placeholderLabel.isHidden = false
    }
    
    @objc func dismiss() {
        resignFirstResponder()
    }
}

extension PlaceholderTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        didChangeText?(textView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        didBeginEditing?(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        didEndEditing?(textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            didReturnTap?(textView)
            return true
        }
        
        return true
    }
}
