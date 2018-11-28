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
import CMPComapiFoundation

class ChatImageMessageCell: BaseTableViewCell {
    
    let bubbleView: UIView
    let contentImageView: UIImageView
    let dateLabel: UILabel
    let loader: UIActivityIndicatorView
    let statusView: MessageStatusView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        bubbleView = UIView()
        contentImageView = UIImageView()
        dateLabel = UILabel()
        loader = UIActivityIndicatorView(style: .white)
        statusView = MessageStatusView(size: 12)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        dateLabel.text = nil
        contentImageView.image = nil
    }
    
    func configure() {
        customize(self)
        customize(bubbleView)
        customize(contentImageView)
        customize(dateLabel)
        customize(loader)
        customize(statusView)
        
        layout(bubbleView)
        layout(contentImageView)
        layout(dateLabel)
        layout(loader)
        layout(statusView)
        
        constrain(bubbleView)
        constrain(contentImageView)
        constrain(dateLabel)
        constrain(loader)
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
        case contentImageView:
            contentImageView.contentMode = .scaleAspectFill
            contentImageView.backgroundColor = .gray
        case loader:
            loader.hidesWhenStopped = true
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
        case contentImageView:
            bubbleView.addSubview(view)
        case loader:
            contentImageView.addSubview(view)

        default:
            break
        }
    }
    
    func constrain(_ view: UIView, _ state: State = .me, _ statusViewHidden: Bool = true) {
        view.snp.remakeConstraints {
            switch view {
            case dateLabel:
                $0.top.equalToSuperview().offset(2)
                $0.width.equalTo(250)
                if state == .me {
                    $0.trailing.equalToSuperview().offset(-18)
                } else {
                    $0.leading.equalToSuperview().offset(18)
                }
            case bubbleView:
                $0.bottom.equalToSuperview().offset(-8)
                $0.top.equalTo(dateLabel.snp.bottom).offset(4)
                $0.width.equalTo(UIScreen.main.bounds.width * (3 / 4))
                $0.height.equalTo(200)
                if !statusViewHidden && state == .me {
                    return
                } else if state == .me {
                    $0.trailing.equalToSuperview().offset(-14)
                } else {
                    $0.leading.equalToSuperview().offset(14)
                }
            case contentImageView:
                $0.edges.equalToSuperview()
            case loader:
                $0.center.equalToSuperview()
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
    
    func configure(with message: Message, state: State, downloader: ImageDownloader, statusViewHidden: Bool = true) {
        guard let parts = message.parts, let participant = message.context?.from, let sentOn = message.context?.sentOn?.ISO8601String() else { return }
        
        dateLabel.text = sentOn
        
        if let delivered = message.statusUpdates?["delivered"] {
            statusView.configure(with: .delivered)
        } else if let read = message.statusUpdates?["read"] {
            statusView.configure(with: .read)
        }
        
        parts.forEach {
            if let url = $0.url {
                loader.startAnimating()
                downloader.download(url, successCompletion: { [weak self] (image) in
                    guard let `self` = self else { return }
                    self.contentImageView.image = image
                    self.loader.stopAnimating()
                }, failureCompletion: { [weak self] _ in
                    guard let `self` = self else { return }
                    self.contentImageView.image = nil
                    self.loader.stopAnimating()
                })
            }
        }
        
        customize(bubbleView, state, statusViewHidden)
        constrain(bubbleView, state, statusViewHidden)
        customize(dateLabel, state)
        constrain(dateLabel, state)
        customize(statusView, state, statusViewHidden)
        constrain(statusView, state, statusViewHidden)
    }
}
