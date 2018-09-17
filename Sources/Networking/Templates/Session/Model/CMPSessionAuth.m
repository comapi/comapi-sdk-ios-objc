//
//  SessionAuth.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 14/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSessionAuth.h"

@implementation CMPSessionAuth

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        if (json[@"token"] && [json[@"token"] isKindOfClass:[NSString class]]) {
            self.token = json[@"token"];
        }
        if (json[@"session"] && [json[@"session"] isKindOfClass:[NSDictionary class]]) {
            self.session = [[CMPSession alloc] initWithJSON:json[@"session"]];
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

- (instancetype)decodeWithData:(NSData *)data error:(NSError *__autoreleasing *)error {
    NSError *serializationError = nil;
    NSDictionary<NSString *, id> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
    if (serializationError) {
        *error = serializationError;
        return nil;
    }
    return [self initWithJSON:json];
}
    
@end
