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


class TextPartView: BaseView {
    
    static let maxTextViewWidth: CGFloat = 200
    
    final let selfAttributes: [NSAttributedString.Key : Any]
    final let otherAttributes: [NSAttributedString.Key : Any]
    
    let bubbleView: UIView
    let textView: UITextView
    
    override init() {
        selfAttributes = [.font : UIFont.systemFont(ofSize: 18), .foregroundColor : UIColor.black]
        otherAttributes = [.font : UIFont.systemFont(ofSize: 18), .foregroundColor : UIColor.white]
        
        bubbleView = UIView(frame: .zero)
        textView = UITextView(frame: .zero)
        
        super.init()
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        layout()
    }
    
    func customize(state: State) {
        self.backgroundColor = .clear

        self.bubbleView.backgroundColor = state == .me ? .white : .black
        self.bubbleView.layer.cornerRadius = 15;
        self.bubbleView.layer.masksToBounds = true;
        self.bubbleView.layer.shadowColor = UIColor.black.cgColor;
        self.bubbleView.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.bubbleView.layer.shadowRadius = 4;
        self.bubbleView.layer.shadowOpacity = 0.14;

        self.textView.isScrollEnabled = false;
        self.textView.backgroundColor = UIColor.clear
        self.textView.isEditable = false;
        self.textView.textAlignment = state == .me ? .right : .left
    }
    
    func layout() {
        addSubview(bubbleView)
        
        bubbleView.addSubview(textView)
    }
    
    func constrain(state: State, applyWidth: Bool) {
        NSLayoutConstraint.deactivate(constraints)
        NSLayoutConstraint.deactivate(bubbleView.constraints)
        NSLayoutConstraint.deactivate(textView.constraints)
        
        bubbleView.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.bottom.equalToSuperview().offset(-4)
            
            if state == .me {
                $0.trailing.equalToSuperview().offset(-14)
            } else {
                $0.leading.equalToSuperview().offset(14)
            }
            
            if applyWidth {
                $0.width.lessThanOrEqualTo(TextPartView.maxTextViewWidth)
            }
        }
        
        textView.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().offset(-4)
            $0.top.equalToSuperview().offset(4)
            $0.bottom.equalToSuperview().offset(-4)
//            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 4, bottom: -4, right: -4))
        }
    }
    
    func configure(with messagePart: MessagePart, state: State) {
        if let data = messagePart.data {
            textView.attributedText = NSAttributedString(string: data, attributes: state == .me ? selfAttributes : otherAttributes)
        }
        
        customize(state: state)
        constrain(state: state, applyWidth: self.shouldApplyWidthConstraint())
    }
    
    func shouldApplyWidthConstraint() -> Bool {
        let size = textView.attributedText.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        return size.width > TextPartView.maxTextViewWidth
    }
}
