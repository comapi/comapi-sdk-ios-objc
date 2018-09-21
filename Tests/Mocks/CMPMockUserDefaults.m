//
//  CMPMockUserDefaults.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 19/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMockUserDefaults.h"

@implementation CMPMockUserDefaults

+ (NSUserDefaults *)mockUserDefaults {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"MOCK_DEFAULTS"];
    return defaults;
}

@end
