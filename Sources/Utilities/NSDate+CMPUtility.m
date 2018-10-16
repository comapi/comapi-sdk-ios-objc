//
//  NSDate+CMPUtility.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 16/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "NSDate+CMPUtility.h"
#import "NSDateFormatter+CMPUtility.h"

@implementation NSDate (CMPUtility)

- (NSString *)ISO8061String {
    return [[NSDateFormatter comapiFormatter] stringFromDate:self];
}

@end
