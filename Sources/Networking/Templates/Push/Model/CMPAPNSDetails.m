//
//  APNSDetails.m
//  CMPComapiFoundation
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
    NSDictionary<NSString *, id> *dict = @{@"bundleID" : self.bundleID,
                                           @"environment" : self.environment,
                                           @"token" : self.token};
    NSError *serializationError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&serializationError];
    if (serializationError) {
        return nil;
    }
    return data;
}

@end


