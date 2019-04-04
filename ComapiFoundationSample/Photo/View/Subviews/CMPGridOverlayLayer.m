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
