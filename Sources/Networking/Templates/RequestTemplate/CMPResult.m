//
//  CMPResult.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 29/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPResult.h"

@implementation CMPResult

- (instancetype)initWithObject:(id)object error:(NSError *)error eTag:(NSString *)eTag code:(NSInteger)code {
    self = [super init];
    
    if (self) {
        self.object = object;
        self.error = error;
        self.eTag = eTag;
        self.code = code;
    }
    
    return self;
}

@end
