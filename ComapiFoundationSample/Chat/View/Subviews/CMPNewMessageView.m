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

#import "CMPNewMessageView.h"

@implementation CMPNewMessageView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.bubbleView = [[UIView alloc] init];
        self.textButton = [UIButton new];
        
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
    self.backgroundColor = UIColor.clearColor;
    
    self.bubbleView.backgroundColor = UIColor.whiteColor;
    self.bubbleView.layer.cornerRadius = 15;
    self.bubbleView.layer.masksToBounds = YES;
    self.bubbleView.layer.shadowColor = UIColor.blackColor.CGColor;
    self.bubbleView.layer.shadowOffset = CGSizeMake(0, 4);
    self.bubbleView.layer.shadowRadius = 4;
    self.bubbleView.layer.shadowOpacity = 0.14;
    self.bubbleView.layer.borderColor = UIColor.whiteColor.CGColor;
    self.bubbleView.layer.borderWidth = 1.0;
    self.bubbleView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.textButton.backgroundColor = UIColor.clearColor;
    [self.textButton setTitleColor:UIColor.blackColor forState:0];
    self.textButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.textButton addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
    self.textButton.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layout {
    [self addSubview:self.bubbleView];
    
    [self.bubbleView addSubview:self.textButton];
}

- (void)constrain {
    NSLayoutConstraint *bubbleTrailing = [self.bubbleView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    NSLayoutConstraint *bubbleLeading = [self.bubbleView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    NSLayoutConstraint *bubbleTop = [self.bubbleView.topAnchor constraintEqualToAnchor:self.topAnchor];
    NSLayoutConstraint *bubbleBottom = [self.bubbleView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    
    [NSLayoutConstraint activateConstraints:@[bubbleTrailing, bubbleLeading, bubbleTop, bubbleBottom]];
    
    NSLayoutConstraint *textTrailing = [self.textButton.trailingAnchor constraintEqualToAnchor:self.textButton.superview.trailingAnchor constant:-4];
    NSLayoutConstraint *textLeading = [self.textButton.leadingAnchor constraintEqualToAnchor:self.textButton.superview.leadingAnchor constant:4];
    NSLayoutConstraint *textTop = [self.textButton.topAnchor constraintEqualToAnchor:self.textButton.superview.topAnchor constant:4];
    NSLayoutConstraint *textBottom = [self.textButton.bottomAnchor constraintEqualToAnchor:self.textButton.superview.bottomAnchor constant:-4];
    
    [NSLayoutConstraint activateConstraints:@[textTrailing, textLeading, textTop, textBottom]];
}

- (BOOL)isVisible {
    return self.alpha > 0.0;
}

- (void)showWithCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:0.33 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)hideWithCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:0.33 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)configureWithText:(NSString *)text {
    [self.textButton setTitle:text forState:0];
}

- (void)tapped {
    if (_didTapView) {
        _didTapView();
    }
}

@end
