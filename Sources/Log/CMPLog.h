//
//  CMPLog.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 28/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPXcodeConsoleDestination.h"
#import "CMPFileDestination.h"

@interface CMPLog : NSObject

+ (CMPXcodeConsoleDestination *)consoleDestination;
+ (CMPFileDestination *)fileDestination;
+ (NSString *)stringFromItems:(NSArray<id> *)items separator:(nullable NSString *)separator terminator:(nullable NSString * )terminator;

@end
