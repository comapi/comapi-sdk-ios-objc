//
//  CMPTestMocks.h
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 13/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPAuthenticationDelegate.h"
#import "CMPRequestPerforming.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPTestMocks : NSObject

+ (NSString *)mockAuthenticationToken;
+ (NSString *)mockApiSpaceID;
+ (NSURL *)mockBaseURL;

@end

NS_ASSUME_NONNULL_END
