//
//  NSHTTPURLResponse+CMPTestUtility.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 17/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "NSHTTPURLResponse+CMPTestUtility.h"

@implementation NSHTTPURLResponse (CMPTestUtility)

+ (instancetype)mockedWithURL:(NSURL *)url {
    return [[NSHTTPURLResponse alloc] initWithURL:url statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:nil];
}

+ (instancetype)mockedWithURL:(NSURL *)url statusCode:(NSUInteger)statusCode httpVersion:(NSString *)httpVersion headers:(NSDictionary<NSString *,NSString *> *)headers {
    return [[NSHTTPURLResponse alloc] initWithURL:url statusCode:statusCode HTTPVersion:httpVersion headerFields:headers];
}

@end
