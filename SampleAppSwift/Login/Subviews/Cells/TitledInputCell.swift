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

class TitledInputCell: BaseTableViewCell {

    let titledTextField: TitledTextField
    
    var didChangeText: ((String) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        titledTextField = TitledTextField()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        customize(self)
        customize(titledTextField)
        
        layout(titledTextField)
        
        constrain(titledTextField)
    }
    
    func customize(_ view: UIView) {
        switch view {
        case self:
            selectionStyle = .none
            contentView.backgroundColor = .gray
        case titledTextField:
            titledTextField.didChangeText = { [weak self] text in
                self?.didChangeText?(text)
            }
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
        view.snp.remakeConstraints {
            switch view {
            case titledTextField:
                $0.top.equalToSuperview().offset(8)
                $0.bottom.equalToSuperview().offset(-8)
                $0.trailing.equalToSuperview().offset(-8)
                $0.leading.equalToSuperview().offset(8)
            default:
                break
            }
        }
    }
    
    func configure(with title: String, value: String?) {
        titledTextField.setup(with: title, value: value)
    }
}
