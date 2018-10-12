//
//  NSURLRequest+CMPUtility.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 12/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "NSURLRequest+CMPUtility.h"
#import "NSData+CMPUtility.h"

@implementation NSURLRequest (CMPUtility)

- (NSString *)description {
    return [@[@"REQUEST:",
              [NSString stringWithFormat:@"%@", self.URL.absoluteString],
              @"BODY:",
              [NSString stringWithFormat:@"%@", [self.HTTPBody utf8StringValue]],
              @"METHOD:",
              [NSString stringWithFormat:@"%@", self.HTTPMethod],
              @"HEADERS:",
              [NSString stringWithFormat:@"%@", self.allHTTPHeaderFields]] componentsJoinedByString:@"\n"];
}

@end
