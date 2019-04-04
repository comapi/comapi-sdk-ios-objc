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

class TitledTextField: BaseView {
    
    var titleLabel: UILabel
    var textField: InsetTextField
    
    var didChangeText: ((String) -> ())?
    
    override init() {
        titleLabel = UILabel()
        textField = InsetTextField()
        
        super.init()
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        customize(self)
        customize(titleLabel)
        customize(textField)
        
        layout(titleLabel)
        layout(textField)
        
        constrain(titleLabel)
        constrain(textField)
    }
    
    func customize(_ view: UIView) {
        switch view {
        case self:
            backgroundColor = .clear
        case titleLabel:
            titleLabel.backgroundColor = .clear
            titleLabel.font = UIFont.systemFont(ofSize: 16)
            titleLabel.textColor = .white
            titleLabel.numberOfLines = 0
        case textField:
            textField.autocapitalizationType = .none
            textField.backgroundColor = .clear
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.white.cgColor
            textField.didChangeText = { [weak self] text in
                self?.didChangeText?(text)
            }
        default:
            break
        }
    }
    
    func layout(_ view: UIView) {
        switch view {
        default:
            addSubview(view)
        }
    }
    
    func constrain(_ view: UIView) {
        view.snp.remakeConstraints {
            switch view {
            case titleLabel:
                $0.top.trailing.leading.equalToSuperview()
            case textField:
                $0.top.equalTo(titleLabel.snp.bottom).offset(8)
                $0.bottom.trailing.leading.equalToSuperview()
                $0.height.greaterThanOrEqualTo(40)
            default:
                break
            }
        }
    }
    
    func clear() {
        textField.text = ""
    }
    
    func setup(with title: String, value: String? = nil) {
        titleLabel.text = title
        textField.text = value ?? ""
        
    }
    
    func editingEnabled(_ enabled: Bool) {
        textField.isEnabled = enabled
    }
    
    @objc func textChanged() {
        didChangeText?(textField.text ?? "")
    }
    
    @objc func dismiss() {
        textField.resignFirstResponder()
    }
}

