//
//  CMPTitledInputCell.h
//  SampleApp
//
//  Created by Dominik Kowalski on 04/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseCell.h"
#import "CMPTitledTextField.h"

@interface CMPTitledInputCell : CMPBaseCell <CMPViewConfiguring>

@property (nonatomic, strong) CMPTitledTextField *titledTextField;
@property (nonatomic, copy, nullable) void(^didChangeText)(NSString *);

- (void)configureWithTitle:(NSString *)title value:(NSString *)value;

@end
