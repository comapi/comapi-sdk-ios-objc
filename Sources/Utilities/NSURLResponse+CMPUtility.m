//
//  NSURLResponse+CMPUtility.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "NSURLResponse+CMPUtility.h"

@implementation NSURLResponse (CMPUtility)

-(NSHTTPURLResponse *)httpURLResponse {
    return (NSHTTPURLResponse *)self;
}

- (NSInteger)httpStatusCode {
    return [[self httpURLResponse] statusCode];
}

@end
