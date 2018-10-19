//
//  CMPCropOverlayView.m
//  SampleApp
//
//  Created by Dominik Kowalski on 19/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPCropOverlayView.h"

@implementation CMPCropOverlayView

- (instancetype)initWithCropSize:(CGSize)cropSize {
    self = [super init];
    
    if (self) {
        self.cropLayer = [[CMPGridOverlayLayer alloc] initWithSize:cropSize];
        self.cropSize = cropSize;
        
        [self configure];
    }
    
    return self;
}

- (void)configure {
    [self customize];
}

- (void)customize {
    self.userInteractionEnabled = YES;
    self.backgroundColor = UIColor.clearColor;
    [self.layer addSublayer:self.cropLayer];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    return [view isEqual:self] ? nil : view;
}

@end
