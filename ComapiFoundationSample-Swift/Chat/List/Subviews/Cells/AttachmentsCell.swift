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

class AttachmentsCell: UICollectionViewCell {

    let deleteButton: UIButton
    let cellBackgroundView: UIView
    let imageView: UIImageView
    let loader: UIActivityIndicatorView
    
    var didTapDelete: (() -> ())?
    
    override init(frame: CGRect) {
        deleteButton = UIButton(frame: .zero)
        cellBackgroundView = UIView(frame: .zero)
        imageView = UIImageView(frame: .zero)
        loader = UIActivityIndicatorView(style: .white)
        
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        customize()
        layout()
        constrain()
    }
    
    func customize() {
        self.contentView.backgroundColor = .clear

        self.cellBackgroundView.backgroundColor = .black
        self.cellBackgroundView.clipsToBounds = true;
        self.cellBackgroundView.layer.cornerRadius = 8;
        self.cellBackgroundView.layer.borderColor = UIColor.white.cgColor;
        self.cellBackgroundView.layer.borderWidth = 1.0;

        self.imageView.isUserInteractionEnabled = true
        self.imageView.backgroundColor = .clear
        self.imageView.contentMode = .scaleAspectFit

        self.deleteButton.setImage(UIImage(named: "cancel"), for: .normal)
        self.deleteButton.imageView?.contentMode = .scaleAspectFit;
        self.deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)

        self.loader.hidesWhenStopped = true;
    }
    
    func layout() {
        contentView.addSubview(cellBackgroundView)
        
        cellBackgroundView.addSubview(imageView)
        
        imageView.addSubview(deleteButton)
        imageView.addSubview(loader)
    }
    
    func constrain() {
        cellBackgroundView.snp.remakeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(6)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-6)
            $0.leading.equalTo(contentView.snp.leading).offset(6)
            $0.trailing.equalTo(contentView.snp.trailing).offset(6)
        }
        
        imageView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deleteButton.snp.remakeConstraints {
            $0.top.equalTo(imageView.snp.top)
            $0.trailing.equalTo(imageView.snp.trailing)
            $0.width.equalTo(14)
            $0.height.equalTo(14)
        }
        
        loader.snp.remakeConstraints {
            $0.center.equalTo(cellBackgroundView.snp.center)
        }
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
    
    @objc func deleteTapped() {
        didTapDelete?()
    }
}
