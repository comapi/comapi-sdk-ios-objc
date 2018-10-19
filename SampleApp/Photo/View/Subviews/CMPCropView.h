//
//  CMPCropView.h
//  SampleApp
//
//  Created by Dominik Kowalski on 19/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPViewConfiguring.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPCropView : UIScrollView <CMPViewConfiguring, UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) CGSize cropSize;

- (instancetype)initWithCropSize:(CGSize)cropSize image:(UIImage *)image;
- (nullable UIImage *)crop;

@end

NS_ASSUME_NONNULL_END
