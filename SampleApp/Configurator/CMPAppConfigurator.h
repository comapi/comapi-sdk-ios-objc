//
//  CMPAppConfigurator.h
//  SampleApp
//
//  Created by Dominik Kowalski on 31/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPLoginViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPAppConfigurator : NSObject <CMPAuthenticationDelegate>

@property (nonatomic, strong) UIWindow *window;

- (instancetype)initWithWindow:(UIWindow *)window;
- (void)start;
- (void)restart;

@end

NS_ASSUME_NONNULL_END
