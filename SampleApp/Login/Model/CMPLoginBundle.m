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

#import "CMPLoginBundle.h"

@implementation CMPLoginBundle

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID profileID:(NSString *)profileID issuer:(NSString *)issuer audience:(NSString *)audience secret:(NSString *)secret {
    self = [super init];
    if (self) {
        self.apiSpaceID = apiSpaceID;
        self.profileID = profileID;
        self.issuer = issuer;
        self.audience = audience;
        self.secret = secret;
    }
    
    return self;
}

- (BOOL)isValid {
    return self.apiSpaceID != nil && self.profileID != nil && self.issuer != nil && self.audience != nil && self.secret != nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSString *apiSpaceID = [aDecoder decodeObjectForKey:@"apiSpaceID"];
    NSString *profileID = [aDecoder decodeObjectForKey:@"profileID"];
    NSString *issuer = [aDecoder decodeObjectForKey:@"issuer"];
    NSString *audience = [aDecoder decodeObjectForKey:@"audience"];
    NSString *secret = [aDecoder decodeObjectForKey:@"secret"];
    
    self = [self initWithApiSpaceID:apiSpaceID profileID:profileID issuer:issuer audience:audience secret:secret];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.apiSpaceID forKey:@"apiSpaceID"];
    [aCoder encodeObject:self.profileID forKey:@"profileID"];
    [aCoder encodeObject:self.issuer forKey:@"issuer"];
    [aCoder encodeObject:self.audience forKey:@"audience"];
    [aCoder encodeObject:self.secret forKey:@"secret"];
}

@end
