//
//  UIImage+CMPUtilities.h
//  SampleApp
//
//  Created by Dominik Kowalski on 23/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CMPUtilities)

- (nullable instancetype)resizedImageWithNewSize:(CGSize)size;
- (nullable instancetype)resizeToScreenSize;

@end

NS_ASSUME_NONNULL_END
