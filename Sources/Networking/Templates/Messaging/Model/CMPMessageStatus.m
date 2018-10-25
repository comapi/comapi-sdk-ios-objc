//
//  CMPMessageStatusUpdate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMessageStatus.h"
#import "NSDateFormatter+CMPUtility.h"
#import "NSString+CMPUtility.h"

@implementation CMPMessageStatus

- (instancetype)initWithStatus:(NSString *)status timestamp:(NSDate *)timestamp {
    self = [super init];
    
    if (self) {
        self.status = status;
        self.timestamp = timestamp;
    }
    
    return self;
}

#pragma mark - CMPJSONEncoding

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.status forKey:@"status"];
    [dict setValue:[[NSDateFormatter comapiFormatter] stringFromDate:self.timestamp] forKey:@"timestamp"];
    
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
        if (JSON[@"status"] && [JSON[@"status"] isKindOfClass:NSString.class]) {
            self.status = JSON[@"status"];
        }
        if (JSON[@"timestamp"] && [JSON[@"timestamp"] isKindOfClass:NSString.class]) {
            self.timestamp = [(NSString *)JSON[@"timestamp"] asDate];
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
    return [[CMPMessageStatus alloc] initWithJSON:json];
}

@end
