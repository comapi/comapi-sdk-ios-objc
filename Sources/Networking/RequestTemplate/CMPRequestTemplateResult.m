//
//  CMPRequestTemplateResult.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 29/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplateResult.h"

@implementation CMPRequestTemplateResult

-(instancetype)initWithObject:(id)object error:(NSError *)error {
    self = [super init];
    
    if (self) {
        self.object = object;
        self.error = error;
    }
    
    return self;
}

@end
