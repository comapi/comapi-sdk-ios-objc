//
//  CMPConfig.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPComapiConfig.h"
#import "CMPAuthenticationDelegate.h"

@interface CMPComapiConfig()

@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) id<CMPAuthenticationDelegate> authDelegate;

@end

@implementation CMPComapiConfig

@end
