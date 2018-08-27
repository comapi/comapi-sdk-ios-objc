//
//  CMPComapi.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPComapi.h"

@interface CMPComapi ()

+ (instancetype)sharedInstance:(CMPAPIConfiguration *)config;

@end

@implementation CMPComapi

+ (instancetype)initialiseWithConfig:(CMPAPIConfiguration *)config {
    return [CMPComapi sharedInstance:config];
}

+ (instancetype)sharedInstance:(CMPAPIConfiguration *)config {
    static CMPComapi *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CMPComapi alloc] init];
        
    });
    
    return sharedInstance;
}



@end
