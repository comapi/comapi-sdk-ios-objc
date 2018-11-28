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

#import "CMPCropView.h"

@implementation CMPCropView

- (instancetype)initWithCropSize:(CGSize)cropSize image:(UIImage *)image {
    self = [super init];
    
    if (self) {
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.cropSize = cropSize;
        self.image = image;
        
        [self configure];
    }
    
    return self;
}

- (void)configure {
    [self customize];
    [self layout];
    [self constrain];
    [self zooming];
    [self centerScrollViewContents];
}

- (void)customize {
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = YES;
    self.backgroundColor = UIColor.clearColor;
    
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layout {
    [self addSubview:self.imageView];
}

- (void)constrain {
    NSLayoutConstraint *top = [self.imageView.topAnchor constraintEqualToAnchor:self.topAnchor];
    NSLayoutConstraint *leading = [self.imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    NSLayoutConstraint *trailing = [self.imageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    NSLayoutConstraint *bottom = [self.imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    
    [NSLayoutConstraint activateConstraints:@[top, leading, trailing, bottom]];
}

- (void)zooming {
    CGFloat widthScale = self.cropSize.width / self.image.size.width;
    CGFloat heightScale = self.cropSize.height / self.image.size.height;
    CGFloat scaleFactor = MIN(widthScale, heightScale);
    
    self.zoomScale = 1.0;
    self.minimumZoomScale = scaleFactor;
    self.maximumZoomScale = 1 / scaleFactor;
}

- (void)centerScrollViewContents {
    CGSize boundsSize = self.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2;
    } else {
        contentsFrame.origin.x = 0;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2;
    } else {
        contentsFrame.origin.y = 0;
    }
    
    self.imageView.frame = contentsFrame;
}

- (UIImage *)crop {
    CGRect cropFrame = CGRectMake(0, 0, self.cropSize.width, self.cropSize.height);
    CGFloat scale = MAX(self.imageView.image.size.width / self.cropSize.width,
                        self.imageView.image.size.height / self.cropSize.height);
    CGPoint point = self.contentOffset;
    point.x *= scale;
    point.y *= scale;
    
    CGSize size = CGSizeMake(cropFrame.size.width * scale, cropFrame.size.height * scale);
    
    CGRect cutFrame = CGRectMake(point.x, point.y, size.width, size.height);
    if (self.imageView.image.imageOrientation == UIImageOrientationRight) {
        cutFrame = CGRectMake(point.y, point.x, size.height, size.width);
    } else if (self.imageView.image.imageOrientation == UIImageOrientationLeft) {
        cutFrame = CGRectMake(point.y, point.x, size.height, size.width);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.imageView.image CGImage], cutFrame);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return image;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
