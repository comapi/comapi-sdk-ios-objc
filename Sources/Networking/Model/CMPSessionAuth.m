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
    CMPSessionAuth* auth = [[CMPSessionAuth alloc] init];
    if (json[@"token"] && [json[@"token"] isKindOfClass:[NSString class]]) {
        auth.token = json[@"token"];
    }
    if (json[@"session"] && [json[@"session"] isKindOfClass:[NSDictionary class]]) {
        auth.session = [[CMPSession alloc] initWithJSON:json[@"session"]];
    }
    return auth;
}
    
@end
