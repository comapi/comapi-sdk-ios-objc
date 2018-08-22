//
//  NSString+Utility.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 14/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "NSString+CMPUtility.h"
#import "NSDateFormatter+CMPUtility.h"

@implementation NSString (CMPUtility)
    
- (NSDate *)asDate {
    NSDateFormatter *formatter = [NSDateFormatter comapiFormatter];
    NSDate *date = [formatter dateFromString:self];
    
    return date;
}
    
@end


