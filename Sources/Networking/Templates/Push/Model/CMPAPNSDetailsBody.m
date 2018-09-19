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
    NSDictionary<NSString *, id> *apnsDict = @{@"bundleId" : self.apns.bundleID,
                                               @"environment" : self.apns.environment,
                                               @"token" : self.apns.token};
    NSDictionary<NSString *, id> *dict = @{@"apns" : apnsDict};
    NSError *serializationError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&serializationError];
    if (serializationError) {
        *error = serializationError;
        return nil;
    }
    return data;
}

@end
