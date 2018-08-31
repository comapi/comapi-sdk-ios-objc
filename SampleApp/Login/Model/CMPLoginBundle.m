//
//  CMPLoginBundle.m
//  SampleApp
//
//  Created by Dominik Kowalski on 31/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
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
