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

#pragma mark - CMPJSONEncoding

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.apns forKey:@"apns"];
    [dict setValue:self.fcm forKey:@"fcm"];
    
    return dict;
}

- (NSData *)encode {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self json] options:0 error:&error];
    if (error) {
        return nil;
    }
    return data;
}

#pragma mark - CMPJSONDecoding

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

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPMessageAlertPlatforms alloc] initWithJSON:json];
}

@end
