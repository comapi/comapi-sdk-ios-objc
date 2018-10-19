//
//  CMPGridOverlayLayer.m
//  SampleApp
//
//  Created by Dominik Kowalski on 19/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPGridOverlayLayer.h"

@implementation CMPGridOverlayLayer

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    
    if (self) {
        self.gridSize = CGSizeMake(round(size.width), round(size.height));
        
        [self drawGrid];
    }
    
    return self;
}

- (void)drawGrid {
    CGFloat xSpacing = self.gridSize.width / 3;
    CGFloat ySpacing = self.gridSize.height / 3;
    
    NSArray<NSArray<NSValue *> *> *startingPoints = @[@[[NSValue valueWithCGPoint:CGPointMake(xSpacing, 0)],
                                                        [NSValue valueWithCGPoint:CGPointMake(xSpacing * 2, 0)]],
                                                      @[[NSValue valueWithCGPoint:CGPointMake(0, ySpacing)],
                                                        [NSValue valueWithCGPoint:CGPointMake(0, ySpacing * 2)]]];
    NSArray<NSArray<NSValue *> *> *endingPoints   = @[@[[NSValue valueWithCGPoint:CGPointMake(xSpacing, self.gridSize.height)],
                                                        [NSValue valueWithCGPoint:CGPointMake(xSpacing * 2, self.gridSize.height)]],
                                                      @[[NSValue valueWithCGPoint:CGPointMake(self.gridSize.width, ySpacing)],
                                                        [NSValue valueWithCGPoint:CGPointMake(self.gridSize.width, ySpacing * 2)]]];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startingPoints[0][0].CGPointValue];
    [path addLineToPoint:endingPoints[0][0].CGPointValue];
    
    [path moveToPoint:startingPoints[0][1].CGPointValue];
    [path addLineToPoint:endingPoints[0][1].CGPointValue];
    
    [path moveToPoint:startingPoints[1][0].CGPointValue];
    [path addLineToPoint:endingPoints[1][0].CGPointValue];
    
    [path moveToPoint:startingPoints[1][1].CGPointValue];
    [path addLineToPoint:endingPoints[1][1].CGPointValue];
    
    self.strokeColor = UIColor.whiteColor.CGColor;
    self.lineWidth = 1.0;
    self.needsDisplayOnBoundsChange = YES;
    
    [path closePath];
    
    self.path = path.CGPath;
}

@end
