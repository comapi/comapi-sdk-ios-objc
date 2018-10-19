//
//  CMPCropOverlayView.h
//  SampleApp
//
//  Created by Dominik Kowalski on 19/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseView.h"
#import "CMPGridOverlayLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPCropOverlayView : CMPBaseView <CMPViewConfiguring>

@property (nonatomic, strong) CMPGridOverlayLayer *cropLayer;
@property (nonatomic) CGSize cropSize;

- (instancetype)initWithCropSize:(CGSize)cropSize;

@end

NS_ASSUME_NONNULL_END
