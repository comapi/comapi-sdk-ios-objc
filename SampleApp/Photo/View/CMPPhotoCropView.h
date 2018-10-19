//
//  CMPPhotoCropView.h
//  SampleApp
//
//  Created by Dominik Kowalski on 19/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseView.h"
#import "CMPCropView.h"
#import "CMPCropOverlayView.h"
#import "CMPGrayButtonWithWhiteText.h"
#import "CMPPhotoCropViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPPhotoCropView : CMPBaseView <CMPViewConfiguring>

@property (nonatomic, strong) CMPCropView *cropView;
@property (nonatomic, strong) CMPCropOverlayView *overlayView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) CMPGrayButtonWithWhiteText *topButton;
@property (nonatomic, strong) CMPGrayButtonWithWhiteText *bottomButton;

@property (nonatomic, strong, readonly) CMPPhotoCropViewModel *viewModel;

@property (nonatomic, copy) void(^didTapTopButton)(void);
@property (nonatomic, copy) void(^didTapBottomButton)(void);

- (instancetype)initWithViewModel:(CMPPhotoCropViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
