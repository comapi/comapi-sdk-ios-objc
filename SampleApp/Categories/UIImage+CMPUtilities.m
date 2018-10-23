//
//  UIImage+CMPUtilities.m
//  SampleApp
//
//  Created by Dominik Kowalski on 23/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "UIImage+CMPUtilities.h"

@implementation UIImage (CMPUtilities)

- (instancetype)resizedImageWithNewSize:(CGSize)size {
    if (self.size.height == size.height && self.size.width == size.width) {
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (instancetype)resizeToScreenSize {
    CGFloat factor = self.size.height / (UIScreen.mainScreen.bounds.size.width + 16);
    return [self resizedImageWithNewSize:CGSizeMake(self.size.width / factor, self.size.height / factor)];
}

@end
