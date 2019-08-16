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

#import "CMPTextPartView.h"

@import CMPComapiFoundation;

CGFloat const kMaxTextViewWidth = 200;

@interface CMPTextPartView ()

@property (nonatomic, copy, readonly) NSDictionary<NSAttributedStringKey, id> *selfAttributes;
@property (nonatomic, copy, readonly) NSDictionary<NSAttributedStringKey, id> *otherAttributes;

@end

@implementation CMPTextPartView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.bubbleView = [UIView new];
        self.textView = [UITextView new];
        
        _selfAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18],
                            NSForegroundColorAttributeName : UIColor.blackColor};
        _otherAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18],
                             NSForegroundColorAttributeName : UIColor.whiteColor};
        
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
    self.bubbleView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.textView.scrollEnabled = NO;
    self.textView.backgroundColor = UIColor.clearColor;
    self.textView.editable = NO;
    self.textView.textAlignment = ownership == CMPMessageOwnershipSelf ? NSTextAlignmentRight : NSTextAlignmentLeft;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layout {
    [self addSubview:self.bubbleView];
    
    [self.bubbleView addSubview:self.textView];
}

- (void)constrainWithOwnership:(CMPMessageOwnership)ownership applyWidthConstraint:(BOOL)applyWidthConstraint {
    [NSLayoutConstraint deactivateConstraints:[self constraints]];
    [NSLayoutConstraint deactivateConstraints:[self.bubbleView constraints]];
    [NSLayoutConstraint deactivateConstraints:[self.textView constraints]];
    
    NSLayoutConstraint *bubbleTop = [self.bubbleView.topAnchor constraintEqualToAnchor:self.topAnchor constant:4];
    NSLayoutConstraint *bubbleBottom = [self.bubbleView.bottomAnchor constraintEqualToAnchor:self.bubbleView.superview.bottomAnchor constant:-4];
    
    NSLayoutConstraint *bubbleSide;
    if (ownership == CMPMessageOwnershipSelf) {
        bubbleSide = [self.bubbleView.trailingAnchor constraintEqualToAnchor:self.bubbleView.superview.trailingAnchor constant:-14];
    } else {
        bubbleSide = [self.bubbleView.leadingAnchor constraintEqualToAnchor:self.bubbleView.superview.leadingAnchor constant:14];
    }
    
    if (applyWidthConstraint) {
        NSLayoutConstraint *bubbleWidth = [self.bubbleView.widthAnchor constraintLessThanOrEqualToConstant:kMaxTextViewWidth];
        [NSLayoutConstraint activateConstraints:@[bubbleTop, bubbleBottom, bubbleSide, bubbleWidth]];
    } else {
        [NSLayoutConstraint activateConstraints:@[bubbleTop, bubbleBottom, bubbleSide]];
    }
    
    
    NSLayoutConstraint *textViewTop = [self.textView.topAnchor constraintEqualToAnchor:self.textView.superview.topAnchor constant:4];
    NSLayoutConstraint *textViewLeading = [self.textView.leadingAnchor constraintEqualToAnchor:self.textView.superview.leadingAnchor constant:4];
    NSLayoutConstraint *textViewBottom = [self.textView.bottomAnchor constraintEqualToAnchor:self.textView.superview.bottomAnchor constant:-4];
    NSLayoutConstraint *textViewTrailing = [self.textView.trailingAnchor constraintEqualToAnchor:self.textView.superview.trailingAnchor constant:-4];
    
    [NSLayoutConstraint activateConstraints:@[textViewTop, textViewLeading, textViewBottom, textViewTrailing]];
}

- (void)configureWithMessagePart:(CMPMessagePart *)messagePart ownership:(CMPMessageOwnership)ownership {
    if (messagePart.data) {
        self.textView.attributedText = [[NSAttributedString alloc] initWithString:messagePart.data attributes:ownership == CMPMessageOwnershipSelf ? self->_selfAttributes : self->_otherAttributes];
    }
    
    [self customizeWithOwnership:ownership];
    [self constrainWithOwnership:ownership applyWidthConstraint:[self shouldApplyWidthConstraintForOwnership:ownership]];
}

- (BOOL)shouldApplyWidthConstraintForOwnership:(CMPMessageOwnership)ownership {
    CGSize size = [self.textView.attributedText.string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                                    options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:ownership == CMPMessageOwnershipSelf ? self->_selfAttributes : self->_otherAttributes context:nil].size;
    return size.width > kMaxTextViewWidth;
}

@end
