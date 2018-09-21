//
//  CMPLog.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 28/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPLog.h"
#import "CMPConstants.h"

@implementation CMPLog

+ (CMPXcodeConsoleDestination *)consoleDestination {
    return [[CMPXcodeConsoleDestination alloc] initWithMinimumLevel:CMPLogLevelVerbose];
}

+ (CMPFileDestination *)fileDestination {
    return [[CMPFileDestination alloc] initWithMinimumLevel:CMPLogLevelVerbose];
}

+ (NSString *)stringFromItems:(NSArray<id> *)items separator:(NSString *)separator terminator:(NSString *)terminator {
    NSString *actualSeparator = separator;
    NSString *actualTerminator = terminator;
    
    if (!separator) {
        actualSeparator = CMPDefaultSeparator;
    }
    if (!terminator) {
        actualTerminator = CMPDefaultTerminator;
    }
    
    NSMutableArray<NSString *> *components = [NSMutableArray new];
    
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *stringDescription = [NSString stringWithFormat:@"%@", obj];
        if (stringDescription) {
            [components addObject:stringDescription];
        } else {
            [components addObject:actualSeparator];
        }
    }];
    
    return [NSString stringWithFormat:@"%@%@", [components componentsJoinedByString:actualSeparator], actualTerminator];
}

@end
