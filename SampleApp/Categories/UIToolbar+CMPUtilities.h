//
//  UIToolbar+CMPUtilities.h
//  SampleApp
//
//  Created by Dominik Kowalski on 31/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIToolbar (CMPUtilities)

+ (UIToolbar *)toolbarWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
