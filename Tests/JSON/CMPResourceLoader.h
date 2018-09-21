//
//  CMPResourceLoader.h
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 19/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPTestMocks.h"

@interface CMPResourceLoader : NSObject

+ (NSURL *)urlForFile:(NSString *)file extension:(NSString *)extension;
+ (NSData *)loadJSONWithName:(NSString *)JSON;

@end
