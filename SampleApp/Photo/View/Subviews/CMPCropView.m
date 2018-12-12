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
    self.contentMode = UIViewContentModeScaleAspectFit;
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    const CGSize contentSize = self.contentSize;
    const CGSize scrollViewSize = self.bounds.size;

    if (contentSize.width < scrollViewSize.width) {
        contentOffset.x = -(scrollViewSize.width - contentSize.width) / 2.0;
    }

    if (contentSize.height < scrollViewSize.height) {
        contentOffset.y = -(scrollViewSize.height - contentSize.height) / 2.0;
    }

    [super setContentOffset:contentOffset];
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
    CGSize imageViewSize = self.imageView.bounds.size;
    CGSize scrollViewSize = self.bounds.size;
    CGFloat widthScale = scrollViewSize.width / imageViewSize.width;
    CGFloat heightScale = scrollViewSize.height / imageViewSize.height;
    CGFloat minZoomScale = MAX(widthScale, heightScale);
    
    self.minimumZoomScale = minZoomScale;
    self.maximumZoomScale = 8.0;
    
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
    CGFloat scale = UIScreen.mainScreen.scale;
    CGRect cutFrame;
    cutFrame.origin.x = (self.contentOffset.x) / self.zoomScale;
    cutFrame.origin.y = (self.contentOffset.y) / self.zoomScale;
    cutFrame.size.width = ((self.contentOffset.x + (self.image.size.width * scale))) / self.zoomScale;
    cutFrame.size.height = ((self.contentOffset.y + (self.image.size.height * scale))) / self.zoomScale;

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
