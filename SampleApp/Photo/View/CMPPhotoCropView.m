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

#import "CMPPhotoCropView.h"

@implementation CMPPhotoCropView

- (instancetype)initWithViewModel:(CMPPhotoCropViewModel *)viewModel {
    self = [super init];
    
    if (self) {
        self.cropView = [[CMPCropView alloc] initWithCropSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.width) image: viewModel.image];
        self.overlayView = [[CMPCropOverlayView alloc] initWithCropSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.width)];
        self.messageLabel = [UILabel new];
        self.topButton = [[CMPGrayButtonWithWhiteText alloc] init];
        self.bottomButton = [[CMPGrayButtonWithWhiteText alloc] init];
        
        _viewModel = viewModel;
        
        [self configure];
    }
    
    return self;
}

- (void)configure {
    [self customize];
    [self layout];
    [self constrain];
}

- (void)customize {
    self.backgroundColor = UIColor.grayColor;
    
    self.cropView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.overlayView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.messageLabel.font = [UIFont systemFontOfSize:14.0];
    self.messageLabel.text = @"Adjust size and position of your photo";
    self.messageLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.8];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.topButton setTitle:@"Next" forState:0];
    [self.topButton addTarget:self action:@selector(topButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.topButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.bottomButton setTitle:@"Cancel" forState:0];
    [self.bottomButton addTarget:self action:@selector(bottomButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.bottomButton.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layout {
    [self addSubview:self.cropView];
    [self addSubview:self.overlayView];
    [self addSubview:self.messageLabel];
    [self addSubview:self.topButton];
    [self addSubview:self.bottomButton];
}

- (void)constrain {
    NSLayoutConstraint *topCrop = [self.cropView.topAnchor constraintEqualToAnchor:self.topAnchor];
    NSLayoutConstraint *centerXCrop = [self.cropView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor];
    NSLayoutConstraint *widthCrop = [self.cropView.widthAnchor constraintEqualToConstant:UIScreen.mainScreen.bounds.size.width];
    NSLayoutConstraint *heightCrop = [self.cropView.heightAnchor constraintEqualToConstant:UIScreen.mainScreen.bounds.size.width];
    
    [NSLayoutConstraint activateConstraints:@[topCrop, centerXCrop, widthCrop, heightCrop]];
    
    NSLayoutConstraint *topLabel = [self.messageLabel.topAnchor constraintEqualToAnchor:self.cropView.bottomAnchor constant:16];
    NSLayoutConstraint *leadingLabel = [self.messageLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:28];
    NSLayoutConstraint *trailingLabel = [self.messageLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-28];
    
    [NSLayoutConstraint activateConstraints:@[topLabel, leadingLabel, trailingLabel]];
    
    NSLayoutConstraint *bottomButtonTop = [self.topButton.bottomAnchor constraintEqualToAnchor:self.bottomButton.topAnchor constant:-12];
    NSLayoutConstraint *leadingButtonTop = [self.topButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16];
    NSLayoutConstraint *trailingButtonTop = [self.topButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16];
    NSLayoutConstraint *heightButtonTop = [self.topButton.heightAnchor constraintEqualToConstant:44];
    
    [NSLayoutConstraint activateConstraints:@[bottomButtonTop, leadingButtonTop, trailingButtonTop, heightButtonTop]];
    
    NSLayoutConstraint *bottomButtonBottom = [self.bottomButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-12];
    NSLayoutConstraint *leadingButtonBottom = [self.bottomButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16];
    NSLayoutConstraint *trailingButtonBottom = [self.bottomButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16];
    NSLayoutConstraint *heightButtonBottom = [self.bottomButton.heightAnchor constraintEqualToConstant:44];
    
    [NSLayoutConstraint activateConstraints:@[bottomButtonBottom, leadingButtonBottom, trailingButtonBottom, heightButtonBottom]];
}

- (void)topButtonTapped {
    if (self.didTapTopButton) {
        self.didTapTopButton();
    }
}

- (void)bottomButtonTapped {
    if (self.didTapBottomButton) {
        self.didTapBottomButton();
    }
}

@end
