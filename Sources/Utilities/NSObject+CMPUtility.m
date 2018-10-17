//
//  NSObject+CMPUtility.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 17/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "NSObject+CMPUtility.h"

@implementation NSObject (CMPUtility)

- (instancetype)valueOrNull {
    return self != nil ? self : [NSNull null];
}

@end
