//
//  NSURLResponse+CMPUtility.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLResponse (CMPUtility)

- (NSInteger)httpStatusCode;
- (NSHTTPURLResponse *)httpURLResponse;

@end

NS_ASSUME_NONNULL_END
