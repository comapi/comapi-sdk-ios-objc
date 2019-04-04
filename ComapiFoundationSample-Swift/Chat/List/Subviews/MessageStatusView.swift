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

import SnapKit
import CMPComapiFoundation

class MessageStatusView: BaseView {
    
    let imageView: UIImageView
    
    var size: CGFloat
    
    init(size: CGFloat = 24.0) {
        self.size = size
        self.imageView = UIImageView()
        
        super.init()
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        customize(self)
        customize(imageView)
        
        layout(imageView)
        
        constrain(imageView)
    }
    
    func customize(_ view: UIView, _ status: MessageDeliveryStatus = .read) {
        switch self {
        case self:
            backgroundColor = .clear
            layer.borderWidth = 1
            layer.borderColor = UIColor.white.cgColor
            layer.cornerRadius = size / 2
            layer.masksToBounds = true
            clipsToBounds = true
        case imageView:
            imageView.image = UIImage(named: "check")
            imageView.backgroundColor = status == .delivered ? .black : .white
            imageView.contentMode = .scaleAspectFit
        default:
            break
        }
    }
    
    func layout(_ view: UIView) {
        switch view {
        case imageView:
            addSubview(view)
        default:
            break
        }
    }
    
    func constrain(_ view: UIView) {
        view.snp.remakeConstraints {
            switch view {
            case imageView:
                $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
            default:
                break
            }
        }
    }
    
    func configure(with status: MessageDeliveryStatus) {
        customize(imageView, status)
    }
}
