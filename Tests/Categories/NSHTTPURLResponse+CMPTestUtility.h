//
//  NSHTTPURLResponse+CMPTestUtility.h
//  comapi_ios_sdk_objective_c_tests
//
//  Created by Dominik Kowalski on 17/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHTTPURLResponse (CMPTestUtility)

+ (instancetype)mockedWithURL:(NSURL *)url;
+ (instancetype)mockedWithURL:(NSURL *)url statusCode:(NSUInteger)statusCode httpVersion:(NSString *)httpVersion headers:(NSDictionary<NSString *, NSString *> *)headers;

@end

