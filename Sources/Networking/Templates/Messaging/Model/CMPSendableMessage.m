//
//  CMPSendableMessage.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSendableMessage.h"

@implementation CMPSendableMessage

- (instancetype)initWithMetadata:(NSDictionary<NSString *,id> *)metadata parts:(NSArray<CMPMessagePart *> *)parts alert:(CMPMessageAlert *)alert {
    self = [super init];
    
    if (self) {
        self.metadata = metadata;
        self.parts = parts;
        self.alert = alert;
    }
    
    return self;
}

- (id)json {
    NSMutableArray<NSDictionary<NSString *, id> *> *parts = [NSMutableArray new];
    [self.parts enumerateObjectsUsingBlock:^(CMPMessagePart * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parts addObject:[obj json]];
    }];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.metadata forKey:@"metadata"];
    [dict setValue:parts forKey:@"parts"];
    [dict setValue:self.alert forKey:@"alert"];

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

@end
