//
//  CMPMessageAlert.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMessageAlert.h"

@implementation CMPMessageAlert

- (instancetype)initWithPlatforms:(CMPMessageAlertPlatforms *)platforms {
    self = [super init];
    
    if (self) {
        self.platforms = platforms;
    }
    
    return self;
}

- (id)json {
    return @{@"platforms" : self.platforms};
}

- (NSData *)encode {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self json] options:0 error:&error];
    if (error) {
        return nil;
    }
    return data;
}

@end
