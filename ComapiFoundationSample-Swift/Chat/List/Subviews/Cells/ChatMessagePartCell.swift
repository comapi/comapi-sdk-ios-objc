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


enum PartType {
    case image
    case text
    case unknown
}

class ChatMessagePartCell: BaseTableViewCell {
    
    let dateLabel: UILabel
    let profileLabel: UILabel
    let statusLabel: UILabel
    
    var partViews: [UIView]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        partViews = []
        dateLabel = UILabel()
        profileLabel = UILabel()
        statusLabel = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        reset()
    }
    
    func reset() {
        for v in contentView.subviews {
            NSLayoutConstraint.deactivate(v.constraints)
            v.removeFromSuperview()
        }
        partViews = []
        dateLabel.text = nil
        profileLabel.text = nil
        statusLabel.text = nil
    }
    
    func configureSelf() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    func partType(for messagePart: MessagePart) -> PartType {
        switch messagePart.type {
        case "text/plain":
            return .text
        case "comapi/upl", "image/jpg", "image/png":
            return .image
        default:
            return .unknown
        }
    }
    
    func generatePartsView(for parts: [MessagePart]) -> UIView {
        partViews = []
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        for (i, p) in parts.enumerated() {
            let partView: UIView
            switch self.partType(for: p) {
            case .text:
                partView = TextPartView()
            case .image:
                partView = ImagePartView()
            case .unknown:
                partView = UIView()
            }
            view.addSubview(partView)
            partView.snp.remakeConstraints {
                if i == 0 {
                    $0.top.equalTo(view.snp.top)
                } else {
                    $0.top.equalTo(self.partViews[i - 1].snp.bottom)
                }
                $0.leading.equalTo(view.snp.leading)
                $0.trailing.equalTo(view.snp.trailing)
                if i == parts.count - 1 {
                    $0.bottom.equalTo(view.snp.bottom).offset(-2)
                }
            }
            self.partViews.append(partView)
        }
        
        return view
    }
    
    func configureProfileLabel(with profile: String, state: State) {
        self.profileLabel.textColor = state == .me ? .white : .black
        self.profileLabel.textAlignment = state == .me ? .right : .left;
        self.profileLabel.font = UIFont.systemFont(ofSize: 13)
        self.profileLabel.numberOfLines = 0;
        self.profileLabel.text = profile;
        
        contentView.addSubview(profileLabel)
        
        profileLabel.snp.remakeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(8)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
    }
    
    func configureDateLabel(with date: Date?, state: State) {
        self.dateLabel.textColor = state == .me ? .white : .black
        self.dateLabel.textAlignment = state == .me ? .right : .left;
        self.dateLabel.font = UIFont.systemFont(ofSize: 11)
        self.dateLabel.numberOfLines = 0;
        self.dateLabel.text = date?.ISO8601String() ?? ""
        
        contentView.addSubview(dateLabel)
        
        dateLabel.snp.remakeConstraints {
            $0.top.equalTo(profileLabel.snp.bottom).offset(8)
            if state == .me {
                $0.trailing.equalTo(contentView.snp.trailing).offset(-22)
            } else {
                $0.leading.equalTo(contentView.snp.leading).offset(22)
            }
        }
    }
    
    func configureStatusView(for message: Message, state: State) {
        self.statusLabel.textColor = state == .me ? .white : .black
        self.statusLabel.textAlignment = state == .me ? .right : .left;
        self.statusLabel.font = UIFont.systemFont(ofSize: 9)
        self.statusLabel.numberOfLines = 0;
        
        if message.statusUpdates == nil || message.statusUpdates?.count == 0 {
            self.statusLabel.text = "sent"
        } else {
            var deliveryStatus: MessageDeliveryStatus = .delivered
            if state == .me {
                if let id = message.context?.from?.id, let status = message.statusUpdates?.first(where: {$0.0 != id }) {
                    deliveryStatus = status.1.status
                }
            }
            switch deliveryStatus {
            case .delivered:
                self.statusLabel.text = "delivered"
            case .read:
                self.statusLabel.text = "read"
            }
        }

        self.contentView.addSubview(self.statusLabel)
        
        if partViews.count > 0 {
            statusLabel.snp.remakeConstraints {
                $0.top.equalTo(partViews.last!.snp.bottom)
                $0.bottom.equalTo(contentView.snp.bottom).offset(-8).priority(999)
                $0.trailing.equalTo(contentView.snp.trailing).offset(-22)
            }
        }
    }
    
    func configurePartsView(for message: Message, state: State) {
        let partsView = self.generatePartsView(for: message.parts ?? [])
        
        contentView.addSubview(partsView)
        
        partsView.snp.remakeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(4)
            if state == .me {
                $0.trailing.equalTo(contentView.snp.trailing)
            } else {
                $0.leading.equalTo(contentView.snp.leading)
                $0.bottom.equalTo(contentView.snp.bottom).offset(-4).priority(999)
            }
        }
    }
    
    func configure(with message: Message, ownership: State, downloader: ImageDownloader) {
        configureProfileLabel(with: message.context?.from?.id ?? "", state: ownership)
        configureDateLabel(with: message.context?.sentOn, state: ownership)
        configurePartsView(for: message, state: ownership)
        if ownership == .me {
           configureStatusView(for: message, state: ownership)
        }
        if let parts = message.parts {
            for (i, p) in parts.enumerated() {
                if partViews[i] is TextPartView {
                    (partViews[i] as! TextPartView).configure(with: p, state: ownership)
                } else if partViews[i] is ImagePartView {
                    (partViews[i] as! ImagePartView).configure(with: p, state: ownership, downloader: downloader)
                }
            }
        }
    }
}
