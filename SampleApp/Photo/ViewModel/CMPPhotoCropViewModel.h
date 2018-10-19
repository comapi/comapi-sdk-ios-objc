//
//  CMPPhotoCropViewModel.h
//  SampleApp
//
//  Created by Dominik Kowalski on 19/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMPPhotoCropViewModel : NSObject

@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithImage:(UIImage *)image;

- (nullable NSData *)prepareCroppedImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END

