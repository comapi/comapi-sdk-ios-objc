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
import SnapKit

class ChatView: BaseView {

    let tableView: UITableView
    let inputMessageView: ChatInputView
    
    var animatableConstraint: Constraint!
    
    var didTapSendButton: ((_ msg: String) -> ())?
    var didTapUploadButton: (() -> ())?
    
    override init() {
        tableView = UITableView()
        inputMessageView = ChatInputView()
        
        super.init()
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        customize(self)
        customize(tableView)
        customize(inputMessageView)
        
        layout(tableView)
        layout(inputMessageView)
        
        constrain(tableView)
        constrain(inputMessageView)
    }
    
    func customize(_ view: UIView) {
        switch view {
        case self:
            backgroundColor = .gray
        case tableView:
            tableView.keyboardDismissMode = .onDrag
            tableView.backgroundColor = .gray
            tableView.separatorStyle = .none
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 44
            tableView.register(ChatTextMessageCell.self, forCellReuseIdentifier: "textCell")
            tableView.register(ChatImageMessageCell.self, forCellReuseIdentifier: "imageCell")
        case inputMessageView:
            inputMessageView.didTapSendButton = { [weak self] in
                guard let `self` = self else { return }
                self.didTapSendButton?(self.inputMessageView.inputTextView.text)
                self.inputMessageView.inputTextView.clearInput()
            }
            inputMessageView.inputTextView.didChangeText = { [weak self] textView in
                guard let `self` = self else { return }
                self.adjustTableViewContentInset()
                self.scrollToBottom(animated: true)
                self.inputMessageView.sendButton.isEnabled = textView.text != ""
            }
            inputMessageView.didTapUploadButton = { [weak self] in
                guard let `self` = self else { return }
                self.didTapUploadButton?()
            }
            
        default:
            break
        }
    }
    
    func layout(_ view: UIView) {
        switch view {
        case tableView, inputMessageView:
            addSubview(view)
        default:
            break
        }
    }
    
    func constrain(_ view: UIView) {
        view.snp.remakeConstraints {
            switch view {
            case inputMessageView:
                $0.trailing.leading.equalToSuperview()
                if #available(iOS 11.0, *) {
                    animatableConstraint = $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).constraint
                } else {
                    animatableConstraint = $0.bottom.equalToSuperview().constraint
                }
            case tableView:
                $0.top.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(inputMessageView.snp.top)
            default:
                break
            }
        }
    }
    
    func animateOnKeyboardChange(notification: Notification, completion: (() -> ())?) {
        guard let info = notification.userInfo else { return }
        let name = notification.name
        let curve = UIView.AnimationCurve(rawValue: (info[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)!
        let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let endFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [UIView.AnimationOptions(rawValue: UInt(curve.rawValue))], animations: {
            if name == UIResponder.keyboardWillShowNotification {
                self.animatableConstraint.update(offset: -endFrame.height)
            } else {
                self.animatableConstraint.update(offset: 0.0)
            }
            self.tableView.contentInset = .zero
            self.layoutIfNeeded()
            self.scrollToBottom(animated: false)
        }) { _ in
            completion?()
        }
    }
    
    func scrollToBottom(animated: Bool) {
        if tableView.contentSize.height < tableView.bounds.height { return }
        let bottomOffset = tableView.contentSize.height - tableView.bounds.size.height
        tableView.setContentOffset(CGPoint(x: 0.0, y: bottomOffset), animated: animated)
    }
    
    func adjustTableViewContentInset() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: inputMessageView.bounds.height, right: 0)
        layoutIfNeeded()
    }
}
