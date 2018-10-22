//
//  CMPPhotoCropViewModel.m
//  SampleApp
//
//  Created by Dominik Kowalski on 19/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPPhotoCropViewModel.h"

@implementation CMPPhotoCropViewModel

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    
    if (self) {
        self.image = image;
    }
    
    return self;
}

- (NSData *)prepareCroppedImage:(UIImage *)image {
    return UIImageJPEGRepresentation(image, 0.6);
}

@end
