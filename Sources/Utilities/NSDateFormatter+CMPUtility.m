//
//  NSDateFormatter+Utility.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 14/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "NSDateFormatter+CMPUtility.h"

@implementation NSDateFormatter (CMPUtility)
    
+ (NSDateFormatter *)iso8061Formatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.timeZone = [[NSTimeZone alloc] initWithName:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    return formatter;
}

+ (NSDateFormatter *)comapiFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSX";
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    return formatter;
}
    
@end
