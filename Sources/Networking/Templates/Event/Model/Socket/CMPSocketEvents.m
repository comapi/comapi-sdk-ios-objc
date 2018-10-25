//
//  CMPSessionEvents.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 11/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSocketEvents.h"

@implementation CMPSocketEventInfo

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"socketId"] && [JSON[@"socketId"] isKindOfClass:NSString.class]) {
            self.socketID = JSON[@"socketId"];
        }
        if (JSON[@"accountId"] && [JSON[@"accountId"] isKindOfClass:NSNumber.class]) {
            self.accountID = JSON[@"accountId"];
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
    return [[CMPSocketEventInfo alloc] initWithJSON:json];
}

- (id)json {
    NSMutableDictionary *dict = [super json];
    [dict setValue:self.socketID forKey:@"socketId"];
    [dict setValue:self.accountID forKey:@"accountId"];
    
    return dict;
}


@end
