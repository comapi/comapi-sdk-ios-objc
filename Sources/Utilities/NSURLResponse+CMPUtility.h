//
//  NSURLResponse+CMPUtility.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLResponse (CMPUtility)

- (NSInteger)httpStatusCode;
- (NSHTTPURLResponse *)httpURLResponse;

@end
