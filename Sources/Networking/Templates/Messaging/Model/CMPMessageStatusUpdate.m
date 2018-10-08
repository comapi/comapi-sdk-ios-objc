//
//  CMPMessageStatusUpdate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMessageStatusUpdate.h"
#import "NSDateFormatter+CMPUtility.h"
#import "NSString+CMPUtility.h"

@implementation CMPMessageStatusUpdate

- (instancetype)initWithStatus:(NSString *)status on:(NSDate *)on {
    self = [super init];
    
    if (self) {
        self.status = status;
        self.on = on;
    }
    
    return self;
}

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"status"] && [JSON[@"status"] isKindOfClass:NSString.class]) {
            self.status = JSON[@"status"];
        }
        if (JSON[@"on"] && [JSON[@"on"] isKindOfClass:NSString.class]) {
            self.on = [(NSString *)JSON[@"on"] asDate];
        }
    }
    
    return self;
}

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
}

- (id)json {
    return @{@"status" : self.status,
             @"on" : [[NSDateFormatter comapiFormatter] stringFromDate:self.on]};
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
