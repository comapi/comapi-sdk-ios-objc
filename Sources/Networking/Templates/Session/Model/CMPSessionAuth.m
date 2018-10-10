//
//  SessionAuth.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 14/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSessionAuth.h"

@implementation CMPSessionAuth

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    if (self) {
        if (JSON[@"token"] && [JSON[@"token"] isKindOfClass:[NSString class]]) {
            self.token = JSON[@"token"];
        }
        if (JSON[@"session"] && [JSON[@"session"] isKindOfClass:[NSDictionary class]]) {
            self.session = [[CMPSession alloc] initWithJSON:JSON[@"session"]];
        }
    }
    return self;
}

- (instancetype)initWithToken:(NSString *)token session:(CMPSession *)session {
    self = [super init];
    if (self) {
        self.token = token;
        self.session = session;
    }
    return self;
}

- (instancetype)decodeWithData:(NSData *)data {
    NSError *serializationError = nil;
    NSDictionary<NSString *, id> *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
    if (serializationError) {
        return nil;
    }
    return [self initWithJSON:JSON];
}
    
@end
