//
//  CMPInsetTextField.h
//  SampleApp
//
//  Created by Dominik Kowalski on 31/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPViewConfiguring.h"

@interface CMPInsetTextField : UITextField <CMPViewConfiguring>

@property (nonatomic, strong) void(^didChangeText)(NSString *);

- (instancetype)init;

@end
