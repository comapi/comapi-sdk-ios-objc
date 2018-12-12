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

class SeparatorCell: UITableViewCell {
    
    let topSeparator: Separator
    let bottomSeparator: Separator
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        topSeparator = Separator(color: .white)
        bottomSeparator = Separator(color: .white)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        customize(self)
        
        layout(topSeparator)
        layout(bottomSeparator)
        
        constrain(topSeparator)
        constrain(bottomSeparator)
    }
    
    func customize(_ view: UIView) {
        switch view {
        case self:
            selectionStyle = .none
            backgroundColor = .clear
            contentView.backgroundColor = .clear
        default:
            break
        }
    }
    
    func layout(_ view: UIView) {
        switch view {
        default:
            contentView.addSubview(view)
        }
    }
    
    func constrain(_ view: UIView) {
        view.snp.makeConstraints {
            switch view {
            case topSeparator:
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview().offset(8)
                $0.trailing.equalToSuperview().offset(-8)
                $0.height.equalTo(1)
            case bottomSeparator:
                $0.bottom.equalToSuperview()
                $0.leading.equalToSuperview().offset(8)
                $0.trailing.equalToSuperview().offset(-8)
                $0.height.equalTo(1)
            default:
                break
            }
        }
    }
    
    func configure(topSeparator topVisible: Bool, bottomSeparator bottomVisible: Bool) {
        topSeparator.isHidden = !topVisible
        bottomSeparator.isHidden = !bottomVisible
    }
    
}
