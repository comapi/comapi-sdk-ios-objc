//
//  HTTPHeader.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 20/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPHTTPHeader.h"

@implementation CMPHTTPHeader

- (instancetype)initWithField:(NSString *)field value:(NSString *)value {
    self = [super init];
    
    if (self) {
        self.field = field;
        self.value = value;
    }
    
    return self;
}

@end
