//
//  CMPPlaceholderTextView.h
//  SampleApp
//
//  Created by Dominik Kowalski on 31/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPViewConfiguring.h"

@interface CMPPlaceholderTextView : UITextView <CMPViewConfiguring, UITextViewDelegate>

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, copy, nullable) void(^didBeginEditing)(UITextView *);
@property (nonatomic, copy, nullable) void(^didEndEditing)(UITextView *);
@property (nonatomic, copy, nullable) void(^didChangeText)(UITextView *);
@property (nonatomic, copy, nullable) void(^didReturnTap)(UITextView *);

- (instancetype)init;

- (void)setPlaceholderWithText:(NSString *)text;
- (void)clearInput;
- (void)dismiss;

@end
