//
//  CMPGridOverlayLayer.h
//  SampleApp
//
//  Created by Dominik Kowalski on 19/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMPGridOverlayLayer : CAShapeLayer

@property (nonatomic) CGSize gridSize;

- (instancetype)initWithSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
