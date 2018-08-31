//
//  CMPViewConfiguring.h
//  SampleApp
//
//  Created by Dominik Kowalski on 31/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMPViewConfiguring

@required
- (void)configure;

@optional
- (void)customize;
- (void)layout;
- (void)constrain;

@end
