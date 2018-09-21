//
//  CMPMockAuthenticationDelegate.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 19/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMockAuthenticationDelegate.h"

@implementation CMPMockAuthenticationDelegate

- (void)clientWith:(nonnull CMPComapiClient *)client didReceiveAuthenticationChallenge:(nonnull CMPAuthenticationChallenge *)challenge completion:(nonnull void (^)(NSString * _Nullable))continueWithToken {
    continueWithToken([CMPTestMocks mockAuthenticationToken]);
}

@end
