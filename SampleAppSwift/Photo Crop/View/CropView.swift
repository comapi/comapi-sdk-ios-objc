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

class CropView: UIScrollView {
    
    var imageView: UIImageView
    var image: UIImage
    var cropSize: CGSize
    
    override var contentOffset: CGPoint {
        set {
            var newOffset = newValue
            let contentSize = self.contentSize
            let scrollViewSize = self.bounds.size
            
            if contentSize.width < scrollViewSize.width {
                newOffset.x = -(scrollViewSize.width - contentSize.width) / 2.0
            }
            
            if (contentSize.height < scrollViewSize.height) {
                newOffset.y = -(scrollViewSize.height - contentSize.height) / 2.0
            }
            
            super.contentOffset = newOffset
        }
        
        get {
            return super.contentOffset
        }
    }
    
    init(image: UIImage, cropSize: CGSize) {
        self.image = image
        self.imageView = UIImageView(image: image)
        self.cropSize = cropSize

        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        customize(self)
        customize(imageView)
        layout(imageView)
        constrain(imageView)
        zooming()
        centerScrollViewContents()
    }
    

    func customize(_ view: UIView) {
        switch view {
        case self:
            delegate = self
            showsVerticalScrollIndicator = false
            showsHorizontalScrollIndicator = false
            backgroundColor = .clear
            contentMode = .scaleAspectFit
        case imageView:
            imageView.contentMode = .scaleAspectFill
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
        view.snp.makeConstraints {
            switch view {
            case imageView:
                $0.edges.equalToSuperview()
            default:
                break
            }
        }
    }

    private func zooming() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        let scaleFactor = max(widthScale, heightScale)
        
        minimumZoomScale = scaleFactor
        maximumZoomScale = 8.0
    }
    
    func centerScrollViewContents() {
        let boundsSize = bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
    }
    
    func crop() -> UIImage? {
        let scale = UIScreen.main.scale
        var cropFrame = CGRect.zero;
        cropFrame.origin.x = contentOffset.x / zoomScale
        cropFrame.origin.y = contentOffset.y / zoomScale
        cropFrame.size.width = (contentOffset.x + (self.image.size.width * scale)) / zoomScale
        cropFrame.size.height = (contentOffset.y + (self.image.size.height * scale)) / zoomScale

        guard let cgImage = imageView.image?.cgImage?.cropping(to: cropFrame) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}

extension CropView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
