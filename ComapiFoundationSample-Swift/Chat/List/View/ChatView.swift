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
    let attachmentsView: AttachmentsView
    let newMessageView: NewMessageView
    
    var animatableConstraint: Constraint!
    
    var didTapSendButton: ((_ msg: String) -> ())?
    var didTapUploadButton: (() -> ())?
    var didTapNewMessageView: (() -> ())?
    
    override init() {
        tableView = UITableView()
        inputMessageView = ChatInputView()
        attachmentsView = AttachmentsView(frame: .zero)
        newMessageView = NewMessageView(frame: .zero)
        
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
        customize(attachmentsView)
        customize(newMessageView)
        
        layout(tableView)
        layout(inputMessageView)
        layout(attachmentsView)
        layout(newMessageView)
        
        constrain(tableView)
        constrain(inputMessageView)
        constrain(attachmentsView)
        constrain(newMessageView)
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
            tableView.register(ChatMessagePartCell.self, forCellReuseIdentifier: "cell")
        case inputMessageView:
            inputMessageView.didTapSendButton = { [weak self] in
                guard let `self` = self else { return }
                self.didTapSendButton?(self.inputMessageView.inputTextView.text)
                self.inputMessageView.inputTextView.clearInput()
            }
            inputMessageView.inputTextView.didChangeText = { [weak self] textView in
                guard let `self` = self else { return }
                self.inputMessageView.sendButton.isEnabled = textView.text != "" || self.attachmentsView.collectionView.numberOfItems(inSection: 0) > 0
            }
            inputMessageView.didTapUploadButton = { [weak self] in
                guard let `self` = self else { return }
                self.didTapUploadButton?()
            }
        case attachmentsView:
            self.attachmentsView.alpha = 0.0;
        case newMessageView:
            newMessageView.configure(with: "New message!")
            newMessageView.alpha = 0.0
            newMessageView.didTap = { [weak self] in
                self?.didTapNewMessageView?()
            }
        default:
            break
        }
    }
    
    func layout(_ view: UIView) {
        switch view {
        case tableView, inputMessageView, attachmentsView, newMessageView:
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
            case attachmentsView:
                $0.trailing.equalToSuperview()
                $0.leading.equalToSuperview()
                $0.bottom.equalTo(inputMessageView.snp.top)
                $0.height.equalTo(64)
            case newMessageView:
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(attachmentsView.snp.top).offset(-8)
                $0.height.equalTo(44)
            default:
                break
            }
        }
    }
    
    func reloadAttachments() {
        attachmentsView.reload()
    }
    
    func toggleAttachments(show: Bool, completion: (() -> ())?) {
        let alpha: CGFloat = show ? 1.0 : 0.0
        if attachmentsView.alpha == alpha {
            completion?()
            return
        }
        
        UIView.animate(withDuration: 0.33, animations: {
            self.attachmentsView.alpha = alpha
        }) { (success) in
            completion?()
        }
    }
    
    func toggleNewMessageView(show: Bool, completion: (() -> ())?) {
        newMessageView.toggle(show: show, completion: completion)
    }
    
    func animateOnKeyboardChange(notification: Notification, completion: (() -> ())?) {
        guard let info = notification.userInfo else { return }
        let name = notification.name
        let curve = UIView.AnimationCurve(rawValue: (info[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)!
        let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let endFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if name == UIResponder.keyboardWillShowNotification {
            self.animatableConstraint.update(offset: -endFrame.height)
        } else {
            self.animatableConstraint.update(offset: 0.0)
        }
        UIView.animate(withDuration: duration, delay: 0.0, options: [UIView.AnimationOptions(rawValue: UInt(curve.rawValue))], animations: {
            self.layoutIfNeeded()
        }) { _ in
            completion?()
        }
    }
    
    func scrollToBottom(animated: Bool) {
        if tableView.contentSize.height < tableView.bounds.height { return }
        let bottomOffset = tableView.contentSize.height - tableView.bounds.size.height
        tableView.setContentOffset(CGPoint(x: 0.0, y: bottomOffset), animated: animated)
    }
    
    func adjustedContentInset(with additionalHeight: CGFloat) -> CGFloat {
        let offset = self.attachmentsView.alpha == 0.0 ? 0.0 + additionalHeight : self.attachmentsView.bounds.size.height + additionalHeight
        return offset
    }
    
    func adjustTableViewContentInset() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: adjustedContentInset(with: 0), right: 0)
        layoutIfNeeded()
    }
}
