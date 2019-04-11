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

#import "CMPAttachmentsView.h"
#import "CMPAttachmentCell.h"

@interface CMPAttachmentsView ()

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation CMPAttachmentsView

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 4;
        _flowLayout.minimumLineSpacing = 4;
        _flowLayout.itemSize = CGSizeMake(64, 64);
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
        
        [self configure];
    }
    
    return self;
}

- (BOOL)isEmpty {
    return [_collectionView.dataSource collectionView:_collectionView numberOfItemsInSection:0] == 0;
}

- (void)configure {
    [self customize];
    [self layout];
    [self constrain];
}

- (void)customize {
    self.backgroundColor = UIColor.clearColor;
    
    self.collectionView.backgroundColor = UIColor.grayColor;
    self.collectionView.allowsSelection = NO;
    [self.collectionView registerClass:CMPAttachmentCell.class forCellWithReuseIdentifier:@"cell"];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layout {
    [self addSubview:self.collectionView];
}

- (void)constrain {
    NSLayoutConstraint *top = [self.collectionView.topAnchor constraintEqualToAnchor:self.topAnchor];
    NSLayoutConstraint *bottom = [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    NSLayoutConstraint *leading = [self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    NSLayoutConstraint *trailing = [self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    
    [NSLayoutConstraint activateConstraints:@[top, bottom, leading, trailing]];
}

- (void)reload {
    [self.collectionView reloadData];
}

@end
