//
//  CMPAuthenticationManager.m
//  SampleApp
//
//  Created by Dominik Kowalski on 04/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAuthenticationManager.h"
#import <JWT/JWT.h>

@implementation CMPAuthenticationManager

+ (NSString *)generateTokenForNonce:(NSString *)nonce profileID:(NSString *)profileID issuer:(NSString *)issuer audience:(NSString *)audience secret:(NSString *)secret {
    NSDate *now = [NSDate date];
    NSDate *exp = [NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitDay value:30 toDate:now options:0];
    
    NSDictionary *headers = @{@"typ" : @"JWT"};
    NSDictionary *payload = @{@"nonce" : nonce,
                               @"sub" : profileID,
                               @"iss" : issuer,
                               @"aud" : audience,
                               @"iat" : [NSNumber numberWithDouble:now.timeIntervalSince1970],
                               @"exp" : [NSNumber numberWithDouble:exp.timeIntervalSince1970]};
    
    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    id<JWTAlgorithm> algorithm = [JWTAlgorithmFactory algorithmByName:@"HS256"];
    
    NSString *token = [JWTBuilder encodePayload:payload].headers(headers).secretData(secretData).algorithm(algorithm).encode;
    return token;
}

@end
