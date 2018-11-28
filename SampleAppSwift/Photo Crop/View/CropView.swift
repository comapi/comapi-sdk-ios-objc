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
        zooming()
        customize(self)
        customize(imageView)
        layout(imageView)
        constrain(imageView)
        centerScrollViewContents()
    }
    

    func customize(_ view: UIView) {
        switch view {
        case self:
            showsVerticalScrollIndicator = false
            showsHorizontalScrollIndicator = false
            backgroundColor = .clear
        case imageView:
            imageView.contentMode = .scaleToFill
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
        let widthScale = cropSize.width / image.size.width
        let heightScale = cropSize.height / image.size.height
        let scaleFactor = min(widthScale, heightScale)
        
        zoomScale = 1.0
        minimumZoomScale = scaleFactor
        maximumZoomScale = 1 / scaleFactor
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
        let cropFrame = CGRect(x: 0, y: 0, width: cropSize.width, height: cropSize.height)
        
        let scale = max(imageView.image!.size.width / cropSize.width,
                                 imageView.image!.size.height / cropSize.height)
        
        var point = contentOffset
        point.x *= scale
        point.y *= scale
        
        let size = CGSize(width: cropFrame.size.width * scale, height: cropFrame.size.height * scale)
        
        var cutFrame = CGRect(x: point.x, y: point.y, width: size.width, height: size.height)
        if imageView.image!.imageOrientation == .right {
            cutFrame = CGRect(x: point.y, y: point.x, width: size.height, height: size.width)
        } else if imageView.image!.imageOrientation == .left {
            cutFrame = CGRect(x: point.y, y: point.x, width: size.height, height: size.width)
        } else if imageView.image!.imageOrientation == .down {
            
        }
        
        let cgImage = imageView.image!.cgImage!.cropping(to: cutFrame)
        let image = UIImage(cgImage: cgImage!, scale: imageView.image!.scale, orientation: imageView.image!.imageOrientation)
        
        return image
    }
}

extension CropView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
