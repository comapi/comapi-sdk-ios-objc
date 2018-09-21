//
//  AuthenticationChallenge.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAuthenticationChallenge.h"
#import "NSString+CMPUtility.h"

@implementation CMPAuthenticationChallenge

- (instancetype)initWithJSON:(NSDictionary<NSString *,id> *)json {
    CMPAuthenticationChallenge* challenge = [[CMPAuthenticationChallenge alloc] init];
    
    if (json[@"authenticationId"] != nil && [json[@"authenticationId"] isKindOfClass:[NSString class]]) {
        challenge.authenticationID = json[@"authenticationId"];
    }
    if (json[@"nonce"] != nil && [json[@"nonce"] isKindOfClass:[NSString class]]) {
        challenge.nonce = json[@"nonce"];
    }
    if (json[@"provider"] != nil && [json[@"provider"] isKindOfClass:[NSString class]]) {
        challenge.provider = json[@"provider"];
    }
    if (json[@"expiresOn"] != nil && [json[@"expiresOn"] isKindOfClass:[NSString class]]) {
        challenge.expiresOn = [(NSString *)json[@"expiresOn"] asDate];
    }

    return challenge;
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
