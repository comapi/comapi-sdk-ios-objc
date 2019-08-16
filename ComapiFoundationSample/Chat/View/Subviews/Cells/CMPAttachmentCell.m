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

#import "CMPAttachmentCell.h"

@implementation CMPAttachmentCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.deleteButton = [UIButton new];
        self.cellBackgroundView = [UIView new];
        self.imageView = [UIImageView new];
        self.loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
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
    self.contentView.backgroundColor = UIColor.clearColor;
    
    self.cellBackgroundView.backgroundColor = UIColor.blackColor;
    self.cellBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cellBackgroundView.clipsToBounds = YES;
    self.cellBackgroundView.layer.cornerRadius = 8;
    self.cellBackgroundView.layer.borderColor = UIColor.whiteColor.CGColor;
    self.cellBackgroundView.layer.borderWidth = 1.0;
    self.cellBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.imageView setUserInteractionEnabled:YES];
    self.imageView.backgroundColor = UIColor.clearColor;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.deleteButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    self.deleteButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.deleteButton addTarget:self action:@selector(deleteTapped) forControlEvents:UIControlEventTouchUpInside];
    self.deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.loader.hidesWhenStopped = YES;
    self.loader.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layout {
    [self.contentView addSubview:_cellBackgroundView];
    
    [self.cellBackgroundView addSubview:_imageView];
    
    [self.imageView addSubview:_deleteButton];
    [self.imageView addSubview:_loader];
}

- (void)constrain {
    NSLayoutConstraint *bgTop = [self.cellBackgroundView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:6];
    NSLayoutConstraint *bgBottom = [self.cellBackgroundView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-6];
    NSLayoutConstraint *bgLeading = [self.cellBackgroundView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:6];
    NSLayoutConstraint *bgTrailing = [self.cellBackgroundView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-6];
    
    [NSLayoutConstraint activateConstraints:@[bgTop, bgBottom, bgLeading, bgTrailing]];
    
    NSLayoutConstraint *ivTop = [self.imageView.topAnchor constraintEqualToAnchor:self.cellBackgroundView.topAnchor];
    NSLayoutConstraint *ivBottom = [self.imageView.bottomAnchor constraintEqualToAnchor:self.cellBackgroundView.bottomAnchor];
    NSLayoutConstraint *ivLeading = [self.imageView.leadingAnchor constraintEqualToAnchor:self.cellBackgroundView.leadingAnchor];
    NSLayoutConstraint *ivTrailing = [self.imageView.trailingAnchor constraintEqualToAnchor:self.cellBackgroundView.trailingAnchor];
    
    [NSLayoutConstraint activateConstraints:@[ivTop, ivBottom, ivLeading, ivTrailing]];
    
    NSLayoutConstraint *dbCenterX = [self.deleteButton.topAnchor constraintEqualToAnchor:self.imageView.topAnchor];
    NSLayoutConstraint *dbCenterY = [self.deleteButton.trailingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor];
    NSLayoutConstraint *dbWidth = [self.deleteButton.widthAnchor constraintEqualToConstant:14];
    NSLayoutConstraint *dbHeight = [self.deleteButton.heightAnchor constraintEqualToConstant:14];
    
    [NSLayoutConstraint activateConstraints:@[dbCenterX, dbCenterY, dbWidth, dbHeight]];
    
    NSLayoutConstraint *lCenterX = [self.loader.centerXAnchor constraintEqualToAnchor:self.cellBackgroundView.centerXAnchor];
    NSLayoutConstraint *lCenterY = [self.loader.centerYAnchor constraintEqualToAnchor:self.cellBackgroundView.centerYAnchor];
    
    [NSLayoutConstraint activateConstraints:@[lCenterX, lCenterY]];
}

- (void)configureWithImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)deleteTapped {
    if (_didTapDelete) {
        _didTapDelete();
    }
}

@end

