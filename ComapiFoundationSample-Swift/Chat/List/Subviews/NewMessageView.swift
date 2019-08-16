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

class NewMessageView: UIView {
    
    var didTap: (() -> ())?
    
    let bubbleView: UIView
    let textButton: UIButton
    
    override init(frame: CGRect) {
        bubbleView = UIView(frame: .zero)
        textButton = UIButton(frame: .zero)
        
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        customise()
        layout()
        constrain()
    }
    
    func customise() {
        self.backgroundColor = .clear

        self.bubbleView.backgroundColor = .white
        self.bubbleView.layer.cornerRadius = 15;
        self.bubbleView.layer.masksToBounds = true;
        self.bubbleView.layer.shadowColor = UIColor.black.cgColor
        self.bubbleView.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.bubbleView.layer.shadowRadius = 4;
        self.bubbleView.layer.shadowOpacity = 0.14;
        self.bubbleView.layer.borderColor = UIColor.white.cgColor;
        self.bubbleView.layer.borderWidth = 1.0;

        self.textButton.backgroundColor = .clear
        self.textButton.setTitleColor(.black, for: .normal)
        self.textButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        self.textButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    func layout() {
        addSubview(bubbleView)
        
        bubbleView.addSubview(textButton)
    }
    
    func constrain() {
        bubbleView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textButton.snp.remakeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        }
    }
    
    func isVisible() -> Bool {
        return alpha > 0.0
    }
    
    func toggle(show: Bool, completion: (() -> ())?) {
        let alpha: CGFloat = show ? 1.0 : 0.0
        if (self.alpha == alpha) {
            completion?()
            return
        }
        
        UIView.animate(withDuration: 0.33, animations: {
            self.alpha = alpha
        }) { (success) in
            completion?()
        }
    }
    
    func configure(with text: String) {
        self.textButton.setTitle(text, for: .normal)
    }
    
    @objc func tapped() {
        didTap?()
    }
}

