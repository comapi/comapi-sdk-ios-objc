//
//  CMPInsetTextField.m
//  SampleApp
//
//  Created by Dominik Kowalski on 31/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPInsetTextField.h"
#import "UIToolbar+CMPUtilities.h"

@implementation CMPInsetTextField

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    [self configure];
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

- (void)configure {
    self.keyboardAppearance = UIKeyboardAppearanceDark;
    self.layer.cornerRadius = 4.0;
    self.backgroundColor = UIColor.clearColor;
    self.textColor = UIColor.grayColor;
    self.font = [UIFont systemFontOfSize:16];
    [self addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
    self.inputAccessoryView = [UIToolbar toolbarWithTitle:@"Done" target:self action:@selector(dismiss)];
}

- (void)textChanged {
    if (self.didChangeText) {
        self.didChangeText(self.text);
    }
}

- (void)dismiss {
    [self resignFirstResponder];
}

@end
