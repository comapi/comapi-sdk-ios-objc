//
//  UIImage+Helpers.swift
//  Befriend
//
//  Created by Dominik Kowalski on 07/06/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

extension UIImage {
    func resizedImage(newSize: CGSize) -> UIImage? {
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func scaleAspect(width: CGFloat, height: CGFloat) -> UIImage? {
        print("w = \(width), h = \(height)")
        let size = self.size.applying(CGAffineTransform(scaleX: width, y: height))
        let hasAlpha = false
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        if let scaledImage = UIGraphicsGetImageFromCurrentImageContext() {
            return scaledImage
        }
        UIGraphicsEndImageContext()
        
        return nil
    }
    
    func resize() -> UIImage? {
        let screenHeight = UIScreen.main.bounds.height + 16
        let screenWidth = UIScreen.main.bounds.width + 16
        
        let widthFactor = size.width / screenWidth
        let heightFactor = size.height / screenHeight
        
        var resizeFactor = heightFactor
        if size.width > size.height {
            resizeFactor = widthFactor
        }
        
        return resizedImage(newSize: CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor))
    }

    func colored(_ color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        
        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
