//
//  CMPMessageStatusUpdate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 09/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMessageStatusUpdate.h"
#import "NSString+CMPUtility.h"
#import "NSDateFormatter+CMPUtility.h"

@implementation CMPMessageStatusUpdate

- (instancetype)initWithStatus:(NSString *)status timestamp:(NSDate *)timestamp messageIDs:(NSArray<NSString *> *)messageIDs {
    self = [super init];
    
    if (self) {
        self.status = status;
        self.timestamp = timestamp;
        self.messageIDs = messageIDs;
    }
    
    return self;
}

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"status"] && [JSON[@"status"] isKindOfClass:NSString.class]) {
            self.status = JSON[@"status"];
        }
        if (JSON[@"timestamp"] && [JSON[@"timestamp"] isKindOfClass:NSString.class]) {
            self.timestamp = [(NSString *)JSON[@"timestamp"] asDate];
        }
        if (JSON[@"messageIds"] && [JSON[@"messageIds"] isKindOfClass:NSArray.class]) {
            self.messageIDs = JSON[@"messageIds"];
        }
    }
    
    return self;
}

- (nullable instancetype)decodeWithData:(NSData *)data { 
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
}

- (id)json {
    return @{@"status" : self.status,
             @"timestamp" : [[NSDateFormatter comapiFormatter] stringFromDate:self.timestamp],
             @"messageIds" : self.messageIDs};
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
