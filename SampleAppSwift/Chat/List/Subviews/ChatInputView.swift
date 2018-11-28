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

class ChatInputView: BaseView {
    
    let inputTextView: PlaceholderTextView
    var sendButton: UIButton
    var uploadButton: UIButton
    
    var didTapSendButton: (() -> ())?
    var didTapUploadButton: (() -> ())?
    
    override init() {
        inputTextView = PlaceholderTextView()
        sendButton = UIButton()
        uploadButton = UIButton()
        
        super.init()
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        customize(self)
        customize(sendButton)
        customize(uploadButton)
        customize(inputTextView)
        
        layout(sendButton)
        layout(uploadButton)
        layout(inputTextView)
        
        constrain(sendButton)
        constrain(uploadButton)
        constrain(inputTextView)
    }
    
    func customize(_ view: UIView) {
        switch view {
        case self:
            backgroundColor = .gray
        case inputTextView:
            inputTextView.backgroundColor = .clear
            inputTextView.layer.borderWidth = 1.0
            inputTextView.layer.borderColor = UIColor.white.cgColor
            inputTextView.inputAccessoryView = nil
            inputTextView.isScrollEnabled = false
            inputTextView.setPlaceholder(text: "New message...")
            inputTextView.layer.masksToBounds = true
            inputTextView.layer.cornerRadius = 4
            inputTextView.clipsToBounds = true
        case sendButton:
            sendButton.isEnabled = false
            sendButton.setTitle("Send", for: UIControl.State())
            sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            sendButton.setTitleColor(.white, for: .normal)
            sendButton.setTitleColor(.red, for: .disabled)
            sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        case uploadButton:
            uploadButton.isEnabled = true
            uploadButton.setImage(UIImage(named: "photo"), for: UIControl.State())
            uploadButton.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)
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
            case inputTextView:
                $0.height.greaterThanOrEqualTo(40)
                $0.bottom.equalToSuperview().offset(-8)
                $0.top.equalToSuperview().offset(8)
            case sendButton:
                $0.trailing.equalToSuperview().offset(-8)
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(inputTextView.snp.trailing).offset(8)
            case uploadButton:
                $0.leading.equalToSuperview().offset(8)
                $0.centerY.equalToSuperview()
                $0.trailing.equalTo(inputTextView.snp.leading).offset(-8)
            default:
                break
            }
        }
    }
    
    @objc func sendTapped() {
        didTapSendButton?()
    }
    
    @objc func uploadTapped() {
        didTapUploadButton?()
    }
}
