//
//  NSData+CMPUtility.m
//  comapi-ios-sdk-objective-c
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
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

@end
