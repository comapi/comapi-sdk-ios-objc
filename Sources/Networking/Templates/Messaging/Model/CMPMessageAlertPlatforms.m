//
//  CMPMessageAlertPlatforms.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMessageAlertPlatforms.h"

@implementation CMPMessageAlertPlatforms

- (instancetype)initWithApns:(NSDictionary<NSString *,id> *)apns fcm:(NSDictionary<NSString *,id> *)fcm {
    self = [super init];
    
    if (self) {
        self.apns = apns;
        self.fcm = fcm;
    }
    
    return self;
}

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"apns"] && [JSON[@"apns"] isKindOfClass:NSDictionary.class]) {
            self.apns = JSON[@"apns"];
        }
        if (JSON[@"fcm"] && [JSON[@"fcm"] isKindOfClass:NSDictionary.class]) {
            self.fcm = JSON[@"fcm"];
        }
    }
    
    return self;
}

- (id)json {
    return @{@"apns" : self.apns,
             @"fcm" : self.fcm};
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
