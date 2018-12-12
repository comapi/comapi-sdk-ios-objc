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

import CMPComapiFoundation

class ChatTextMessageCell: BaseTableViewCell {

    let bubbleView: UIView
    let textView: UITextView
    let dateLabel: UILabel
    
    let statusView: MessageStatusView
    
    private var otherAttributes: [NSAttributedString.Key : Any]
    private var meAttributes: [NSAttributedString.Key : Any]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        bubbleView = UIView()
        textView = UITextView()
        dateLabel = UILabel()
        statusView = MessageStatusView(size: 12)
        
        otherAttributes = [.font : UIFont.systemFont(ofSize: 18),
                           .foregroundColor : UIColor.white]
        meAttributes = [.font : UIFont.systemFont(ofSize: 18),
                        .foregroundColor : UIColor.black]
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        dateLabel.text = nil
        textView.text = nil
    }
    
    func configure() {
        customize(self)
        customize(bubbleView)
        customize(textView)
        customize(dateLabel)
        customize(statusView)
        
        layout(bubbleView)
        layout(textView)
        layout(dateLabel)
        layout(statusView)
        
        constrain(bubbleView)
        constrain(textView)
        constrain(dateLabel)
        constrain(statusView)
    }
    
    func customize(_ view: UIView, _ state: State = .me, _ statusViewHidden: Bool = true) {
        switch view {
        case self:
            selectionStyle = .none
            backgroundColor = .clear
            contentView.backgroundColor = .clear
        case bubbleView:
            bubbleView.backgroundColor = state == .me ? .white : .black
            bubbleView.layer.cornerRadius = 15
            bubbleView.layer.masksToBounds = true
            bubbleView.layer.shadowColor = UIColor.black.cgColor
            bubbleView.layer.shadowOffset = CGSize(width: 0, height: 4)
            bubbleView.layer.shadowRadius = 4
            bubbleView.layer.shadowOpacity = 0.14
        case textView:
            textView.isScrollEnabled = false
            textView.backgroundColor = .clear
            textView.isEditable = false
        case dateLabel:
            dateLabel.textColor = state == .me ? .white : .black
            dateLabel.textAlignment = state == .me ? .right : .left
            dateLabel.font = UIFont.systemFont(ofSize: 11)
            dateLabel.numberOfLines = 0
        case statusView:
            statusView.isHidden = statusViewHidden
        default:
            break
        }
    }
    
    func layout(_ view: UIView) {
        switch view {
        case bubbleView, dateLabel, statusView:
            contentView.addSubview(view)
        case textView:
            bubbleView.addSubview(view)
        default:
            contentView.addSubview(view)
        }
    }
    
    func constrain(_ view: UIView, _ state: State = .me, _ statusViewHidden: Bool = true) {
        view.snp.remakeConstraints {
            switch view {
            case dateLabel:
                $0.top.equalToSuperview().offset(2)
                $0.width.lessThanOrEqualTo(250)
                if state == .me {
                    $0.trailing.equalToSuperview().offset(-18)
                } else {
                    $0.leading.equalToSuperview().offset(18)
                }
            case bubbleView:
                $0.bottom.equalToSuperview().offset(-8)
                $0.top.equalTo(dateLabel.snp.bottom).offset(4)
                $0.width.lessThanOrEqualTo(250)
                if !statusViewHidden && state == .me {
                    return
                } else if state == .me {
                    $0.trailing.equalToSuperview().offset(-14)
                } else if state == .other {
                    $0.leading.equalToSuperview().offset(14)
                }
            case textView:
                $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
            case statusView:
                if state == .me && !statusViewHidden {
                    $0.leading.equalTo(bubbleView.snp.trailing).offset(4)
                    $0.bottom.equalTo(bubbleView.snp.bottom)
                    $0.trailing.equalToSuperview().offset(-4)
                    $0.size.equalTo(statusView.size)
                }
            default:
                break
            }
        }
    }
    
    func configure(with status: MessageStatusUpdate) {
        
    }
    
    func configure(with message: Message, state: State, statusViewHidden: Bool = true) {
        guard let parts = message.parts, let _ = message.context?.from, let sentOn = message.context?.sentOn?.ISO8601String() else { return }
        
        dateLabel.text = sentOn
        
        if let _ = message.statusUpdates?["delivered"] {
            statusView.configure(with: .delivered)
        } else if let _ = message.statusUpdates?["read"] {
            statusView.configure(with: .read)
        }
        
        parts.forEach {
            if let type = $0.type {
                switch type {
                case "text/plain":
                    if let data = $0.data {
                        textView.attributedText = NSAttributedString(string: data, attributes: state == .me ? meAttributes : otherAttributes)
                    }
                default:
                    break
                }
            }
        }
        
        customize(bubbleView, state, statusViewHidden)
        constrain(bubbleView, state, statusViewHidden)
        customize(textView, state)
        constrain(textView, state)
        customize(dateLabel, state)
        constrain(dateLabel, state)
        customize(statusView, state, statusViewHidden)
        constrain(statusView, state, statusViewHidden)
    }
}
