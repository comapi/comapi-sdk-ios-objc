//
//  NSData+CMPUtility.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 17/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "NSData+CMPUtility.h"

@implementation NSData (CMPUtility)

- (instancetype)initWithInputStream:(NSInputStream *)stream {
    
    NSMutableData *data = [NSMutableData data];
    [stream open];
    NSInteger result;
    uint8_t buffer[1024];
    
    while((result = [stream read:buffer maxLength:1024]) != 0) {
        if(result > 0) {
            [data appendBytes:buffer length:result];
        } else {
            if (result < 0) {
                [NSException raise:@"STREAM_ERROR" format:@"%@", [stream streamError]];
            }
        }
    }
    
    return data;
}

- (NSString *)utf8StringValue {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    }
    NSData *prettyPrintedData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted | NSJSONReadingAllowFragments error:&error];
    if (error) {
        return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    }
    
    return [[NSString alloc] initWithData:prettyPrintedData encoding:NSUTF8StringEncoding];
}

@end
