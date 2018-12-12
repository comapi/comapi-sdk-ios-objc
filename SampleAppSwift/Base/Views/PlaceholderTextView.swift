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
