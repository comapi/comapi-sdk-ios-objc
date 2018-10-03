//
//  CMPLog.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 28/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPXcodeConsoleDestination.h"
#import "CMPFileDestination.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Log)
@interface CMPLog : NSObject

+ (CMPXcodeConsoleDestination *)consoleDestination;
+ (CMPFileDestination *)fileDestination;
+ (NSString *)stringFromItems:(NSArray<id> *)items separator:(nullable NSString *)separator terminator:(nullable NSString * )terminator;

@end

NS_ASSUME_NONNULL_END
