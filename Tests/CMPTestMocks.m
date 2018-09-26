//
//  CMPTestMocks.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 13/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPTestMocks.h"

@implementation CMPTestMocks

+ (NSString *)mockAuthenticationToken {
    return @"MOCK_AUTHENTICATION_TOKEN";
}

+ (NSString *)mockApiSpaceID {
    return @"MOCK_API_SPACE_ID";
}

+ (NSURL *)mockBaseURL {
    return [NSURL URLWithString:@"http://192.168.99.100:8000"];
}

+ (NSErrorDomain)mockErrorDomain {
    return @"comapi.mocks.domain";
}

+ (NSUInteger)mockStatusCode {
    return 11111;
}

@end
