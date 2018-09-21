//
//  NSDateFormatter+Utility.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 14/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDateFormatter (CMPUtility)
    
+ (NSDateFormatter *)iso8061Formatter;
+ (NSDateFormatter *)comapiFormatter;
    
@end

NS_ASSUME_NONNULL_END


