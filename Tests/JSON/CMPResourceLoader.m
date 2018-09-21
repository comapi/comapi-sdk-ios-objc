//
//  CMPResourceLoader.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 19/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPResourceLoader.h"

@implementation CMPResourceLoader

+ (NSBundle *)bundle {
    return [NSBundle bundleForClass:CMPTestMocks.class];
}

+ (NSURL *)urlForFile:(NSString *)file extension:(NSString *)extension {
    return [[CMPResourceLoader bundle] URLForResource:file withExtension:extension];
}

+ (NSData *)loadJSONWithName:(NSString *)JSON {
    return [NSData dataWithContentsOfURL:[CMPResourceLoader urlForFile:JSON extension:@"json"]];
}

@end
