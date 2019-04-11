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

#import "CMPImagePartView.h"

//CGFloat const kMaxImageViewSize = 250;

@interface CMPImagePartView ()

@property (nonatomic, strong) NSLayoutConstraint *bubbleHeight;
@property (nonatomic, strong) NSLayoutConstraint *bubbleWidth;

@end

@implementation CMPImagePartView

- (instancetype)init {
    self = [super init];

    if (self) {
        self.bubbleView = [UIView new];
        self.contentImageView = [UIImageView new];
        self.loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

        [self configure];
    }

    return self;
}

- (void)configure {
    [self layout];
}

- (void)customizeWithOwnership:(CMPMessageOwnership)ownership {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = UIColor.clearColor;

    self.bubbleView.backgroundColor = ownership == CMPMessageOwnershipSelf ? UIColor.whiteColor : UIColor.blackColor;
    self.bubbleView.layer.cornerRadius = 15;
    self.bubbleView.layer.masksToBounds = YES;
    self.bubbleView.layer.shadowColor = UIColor.blackColor.CGColor;
    self.bubbleView.layer.shadowOffset = CGSizeMake(0, 4);
    self.bubbleView.layer.shadowRadius = 4;
    self.bubbleView.layer.shadowOpacity = 0.14;
    self.bubbleView.layer.borderColor = UIColor.whiteColor.CGColor;
    self.bubbleView.layer.borderWidth = 1.0;
    self.bubbleView.translatesAutoresizingMaskIntoConstraints = NO;

    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImageView.backgroundColor = UIColor.grayColor;
    self.contentImageView.translatesAutoresizingMaskIntoConstraints = NO;

    self.loader.hidesWhenStopped = YES;
    self.loader.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layout {
    [self addSubview:self.bubbleView];

    [self.bubbleView addSubview:self.contentImageView];

    [self.contentImageView addSubview:self.loader];
    [self.contentImageView bringSubviewToFront:self.loader];
}

- (void)constrainWithOwnership:(CMPMessageOwnership)ownership {
    NSLayoutConstraint *bubbleTop = [self.bubbleView.topAnchor constraintEqualToAnchor:self.topAnchor constant:4];
    NSLayoutConstraint *bubbleBottom = [self.bubbleView.bottomAnchor constraintEqualToAnchor:self.bubbleView.superview.bottomAnchor constant:-4];
    NSLayoutConstraint *bubbleWidth = [self.bubbleView.widthAnchor constraintEqualToConstant:200];
    NSLayoutConstraint *bubbleHeight = [self.bubbleView.heightAnchor constraintEqualToConstant:200];
    NSLayoutConstraint *trailingSide = [self.bubbleView.trailingAnchor constraintEqualToAnchor:self.bubbleView.superview.trailingAnchor constant:-14];
    NSLayoutConstraint *leadingSide = [self.bubbleView.leadingAnchor constraintEqualToAnchor:self.bubbleView.superview.leadingAnchor constant:14];

    [NSLayoutConstraint activateConstraints:@[bubbleTop, bubbleBottom, trailingSide, leadingSide, bubbleWidth, bubbleHeight]];

    NSLayoutConstraint *contentViewTop = [self.contentImageView.topAnchor constraintEqualToAnchor:self.contentImageView.superview.topAnchor];
    NSLayoutConstraint *contentViewLeading = [self.contentImageView.leadingAnchor constraintEqualToAnchor:self.contentImageView.superview.leadingAnchor];
    NSLayoutConstraint *contentViewBottom = [self.contentImageView.bottomAnchor constraintEqualToAnchor:self.contentImageView.superview.bottomAnchor];
    NSLayoutConstraint *contentViewTrailing = [self.contentImageView.trailingAnchor constraintEqualToAnchor:self.contentImageView.superview.trailingAnchor];

    [NSLayoutConstraint activateConstraints:@[contentViewTop, contentViewLeading, contentViewBottom, contentViewTrailing]];

    NSLayoutConstraint *loaderCenterX = [self.loader.centerXAnchor constraintEqualToAnchor:self.loader.superview.centerXAnchor];
    NSLayoutConstraint *loaderCenterY = [self.loader.centerYAnchor constraintEqualToAnchor:self.loader.superview.centerYAnchor];

    [NSLayoutConstraint activateConstraints:@[loaderCenterX, loaderCenterY]];
}

- (void)configureWithMessagePart:(CMPMessagePart *)messagePart ownership:(CMPMessageOwnership)ownership downloader:(CMPImageDownloader *)downloader {
    [self customizeWithOwnership:ownership];
    [self constrainWithOwnership:ownership];

    [self.loader startAnimating];
    __weak typeof(self) weakSelf = self;
    [downloader downloadFromURL:messagePart.url completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (error) {
        NSLog(@"%@", error.localizedDescription);
        } else {
        weakSelf.contentImageView.image = image;
        [weakSelf.loader stopAnimating];
        }
    }];
}

@end
