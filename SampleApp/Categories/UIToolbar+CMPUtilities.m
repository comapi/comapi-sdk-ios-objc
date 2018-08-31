//
//  UIToolbar+CMPUtilities.m
//  SampleApp
//
//  Created by Dominik Kowalski on 31/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "UIToolbar+CMPUtilities.h"

@implementation UIToolbar (CMPUtilities)

+ (UIToolbar *)toolbarWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button setTitleColor:UIColor.grayColor forState:0];
    [button setTitle:title forState:0];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen.mainScreen bounds].size.width, 40)];
    toolbar.barTintColor = UIColor.whiteColor;
    toolbar.items = @[spacer, barButton];
    return toolbar;
}

@end
