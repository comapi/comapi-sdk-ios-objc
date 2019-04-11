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


class ConversationCell: SeparatorCell {
    
    let dateLabel: UILabel
    let nameLabel: UILabel

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        dateLabel = UILabel()
        nameLabel = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        customize(self)
        customize(dateLabel)
        customize(nameLabel)
        
        layout(dateLabel)
        layout(nameLabel)
        
        constrain(dateLabel)
        constrain(nameLabel)
    }
    
    override func customize(_ view: UIView) {
        super.customize(view)
        switch view {
        case self:
            selectionStyle = .none
            backgroundColor = .clear
            contentView.backgroundColor = .clear
        case nameLabel:
            nameLabel.textColor = .white
            nameLabel.textAlignment = .left
            nameLabel.font = UIFont.systemFont(ofSize: 18)
            nameLabel.numberOfLines = 0
        case dateLabel:
            dateLabel.textColor = .white
            dateLabel.textAlignment = .left
            dateLabel.font = UIFont.systemFont(ofSize: 14)
            dateLabel.numberOfLines = 0
        default:
            break
        }
    }
    
    override func layout(_ view: UIView) {
        super.layout(view)
        switch view {
        case nameLabel, dateLabel:
            contentView.addSubview(view)
        default:
            break
        }
    }
    
    override func constrain(_ view: UIView) {
        super.constrain(view)
        view.snp.makeConstraints {
            switch view {
            case nameLabel:
                $0.height.greaterThanOrEqualTo(24)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                $0.bottom.equalToSuperview().offset(-8)
            case dateLabel:
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                $0.bottom.equalTo(nameLabel.snp.top).offset(-8)
                $0.top.equalToSuperview().offset(8)
            default:
                break
            }
        }
    }
    
    func configure(with conversation: Conversation, bottomSeparator: Bool = false, topSeparator: Bool = false) {
        dateLabel.text = conversation.updatedOn.ISO8601String() ?? ""
        nameLabel.text = conversation.name
        configure(topSeparator: topSeparator, bottomSeparator: bottomSeparator)
    }

}
