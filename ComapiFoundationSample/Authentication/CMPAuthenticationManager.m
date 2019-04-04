//
// The MIT License (MIT)
// Copyright (c) 2017 Comapi (trading name of Dynmark International Limited)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
