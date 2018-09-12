//
//  APNSDetailsBody.m
//  comapi-ios-sdk-objective-c
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

- (nullable NSData *)encode:(NSError *__autoreleasing *)error {
    NSError *serializationError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&serializationError];
    if (serializationError) {
        *error = serializationError;
        return nil;
    }
    return data;
}

@end
