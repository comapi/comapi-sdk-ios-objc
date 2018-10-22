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

#import "CMPAuthenticationChallenge.h"
#import "NSString+CMPUtility.h"

@implementation CMPAuthenticationChallenge

- (instancetype)initWithJSON:(NSDictionary<NSString *,id> *)json {
    CMPAuthenticationChallenge* challenge = [CMPAuthenticationChallenge new];
    
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

- (instancetype)decodeWithData:(NSData *)data {
    NSError *serializationError = nil;
    NSDictionary<NSString *, id> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
    if (serializationError) {
        return nil;
    }
    return [self initWithJSON:json];
}

@end
