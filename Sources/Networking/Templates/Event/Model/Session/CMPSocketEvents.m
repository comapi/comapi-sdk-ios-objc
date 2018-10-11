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
        if (JSON[@"accountId"] && [JSON[@"accountId"] isKindOfClass:NSString.class]) {
            self.accountID = JSON[@"accountId"];
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

@end
