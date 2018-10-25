//
//  APNSDetailsBody.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 30/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAPNSDetailsBody.h"

@implementation CMPAPNSDetailsBody

- (instancetype)initWithAPNSDetails:(CMPAPNSDetails *)apnsDetails {
    self = [super init];
    
    if (self) {
        self.apns = apnsDetails;
    }
    
    return self;
}

#pragma mark - CMPJSONEncoding

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:[self.apns json] forKey:@"apns"];
    
    return dict;
}

- (nullable NSData *)encode {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self json] options:0 error:&error];
    if (error) {
        return nil;
    }
    return data;
}

@end
