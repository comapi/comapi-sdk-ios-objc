//
//  CMPTitledTextField.h
//  SampleApp
//
//  Created by Dominik Kowalski on 31/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseView.h"
#import "CMPInsetTextField.h"

@interface CMPTitledTextField : CMPBaseView <CMPViewConfiguring>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CMPInsetTextField *textField;

@property (nonatomic, copy, nullable) void(^didChangeText)(NSString *);

- (instancetype)init;
- (void)clear;
- (void)setupWithTitle:(NSString *)title value:(NSString *)value;
- (void)editingEnabled:(BOOL)enabled;
- (void)dismiss;

@end
