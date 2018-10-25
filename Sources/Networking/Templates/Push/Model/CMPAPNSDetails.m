//
//  APNSDetails.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 30/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAPNSDetails.h"

@implementation CMPAPNSDetails

- (instancetype)initWithBundleID:(NSString *)bundleID environment:(NSString *)environment token:(NSString *)token {
    self = [super init];
    
    if (self) {
        self.bundleID = bundleID;
        self.environment = environment;
        self.token = token;
    }
    
    return self;
}

#pragma mark - CMPJSONEncoding

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.bundleID forKey:@"bundleId"];
    [dict setValue:self.environment forKey:@"environment"];
    [dict setValue:self.token forKey:@"token"];
    
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


