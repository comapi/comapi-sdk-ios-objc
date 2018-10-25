//
//  SessionAuth.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 14/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSessionAuth.h"

@implementation CMPSessionAuth

- (instancetype)initWithToken:(NSString *)token session:(CMPSession *)session {
    self = [super init];
    if (self) {
        self.token = token;
        self.session = session;
    }
    return self;
}

#pragma mark - CMPJSONRepresentable

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.token forKey:@"token"];
    [dict setValue:[self.session json] forKey:@"session"];
    
    return dict;
}

#pragma mark - CMPJSONDecoding

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

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    NSDictionary<NSString *, id> *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPSessionAuth alloc] initWithJSON:JSON];
}
    
@end
