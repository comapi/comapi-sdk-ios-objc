//
//  CMPURLResult.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 17/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPURLResult.h"

@implementation CMPURLResult

- (instancetype)initWithRequest:(NSURLRequest *)request data:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error {
    self = [super init];
    if (self) {
        self.request = request;
        self.data = data;
        self.response = response;
        self.error = error;
    }
    return self;
}

- (NSString *)description {
    return [@[@"URL_REQUEST:",
              [NSString stringWithFormat:@"%@", self.request],
              @"URL_RESPONSE:",
              [NSString stringWithFormat:@"%@", self.response],
              @"DATA:",
              [NSString stringWithFormat:@"%@", [self.data utf8StringValue]],
              @"ERROR:",
              [NSString stringWithFormat:@"%@", self.error]] componentsJoinedByString:@"\n"];
}

@end
