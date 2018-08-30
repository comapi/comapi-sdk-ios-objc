//
//  APNSDetails.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 30/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAPNSDetails.h"

@implementation CMPAPNSDetails

-(instancetype)initWithBundleID:(NSString *)bundleID environment:(NSString *)environment token:(NSString *)token {
    self = [super init];
    
    if (self) {
        self.bundleID = bundleID;
        self.environment = environment;
        self.token = token;
    }
    
    return self;
}

- (nullable NSData *)encode {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (error) {
        return nil;
    }
    return data;
}

@end


