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

class PhotoCropView: UIView {

    let cropView: CropView
    let photoCropOverlay: PhotoCropOverlayView
    let messageLabel: UILabel
    let topButton: GrayButtonWithWhiteText
    let bottomButton: GrayButtonWithWhiteText
    
    var viewModel: PhotoCropViewModel
    
    var didTapTopButton: (() -> ())?
    var didTapBottomButton: (() -> ())?
    
    init(viewModel: PhotoCropViewModel) {
        cropView = CropView(image: viewModel.image, cropSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        photoCropOverlay = PhotoCropOverlayView(cropSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        messageLabel = UILabel()
        topButton = GrayButtonWithWhiteText()
        bottomButton = GrayButtonWithWhiteText()
        
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        customize(self)
        customize(cropView)
        customize(messageLabel)
        customize(topButton)
        customize(bottomButton)
        
        layout(cropView)
        layout(photoCropOverlay)
        layout(messageLabel)
        layout(topButton)
        layout(bottomButton)
        
        constrain(cropView)
        constrain(photoCropOverlay)
        constrain(messageLabel)
        constrain(topButton)
        constrain(bottomButton)
    }
    
    func customize(_ view: UIView) {
        switch view {
        case self:
            backgroundColor = .gray
        case messageLabel:
            messageLabel.font = UIFont.systemFont(ofSize: 14.0)
            messageLabel.text = "Adjust size and position of your photo"
            messageLabel.textColor = UIColor.white.withAlphaComponent(0.8)
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
        case topButton:
            topButton.setTitle("Next", for: UIControl.State())
            topButton.addTarget(self, action: #selector(topButtonTapped), for: .touchUpInside)
        case bottomButton:
            bottomButton.setTitle("Cancel", for: UIControl.State())
            bottomButton.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
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
        view.snp.makeConstraints {
            switch view {
            case cropView, photoCropOverlay:
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview()
                $0.size.equalTo(UIScreen.main.bounds.width)
                if photoCropOverlay == view {
                    bringSubviewToFront(view)
                }
            case messageLabel:
                $0.trailing.equalToSuperview().offset(-28)
                $0.leading.equalToSuperview().offset(28)
                $0.top.equalTo(cropView.snp.bottom).offset(16)
            case topButton:
                $0.trailing.equalToSuperview().offset(-16)
                $0.leading.equalToSuperview().offset(16)
                $0.bottom.equalTo(bottomButton.snp.top).offset(-12)
                $0.height.equalTo(44)
            case bottomButton:
                $0.trailing.equalToSuperview().offset(-16)
                $0.leading.equalToSuperview().offset(16)
                if #available(iOS 11.0, *) {
                    $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
                } else {
                    $0.bottom.equalToSuperview().offset(-16)
                }
                $0.height.equalTo(44)
            default:
                break
            }
        }
    }
    
    @objc func topButtonTapped() {
        didTapTopButton?()
    }
    
    @objc func bottomButtonTapped() {
        didTapBottomButton?()
    }
}
