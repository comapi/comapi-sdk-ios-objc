//
//  Session.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 14/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSession.h"

@implementation CMPSession

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    
    if (self) {
        if (json[@"id"] != nil && [json[@"id"] isKindOfClass:[NSString class]]) {
            self.id = json[@"id"];
        }
        if (json[@"nonce"] != nil && [json[@"nonce"] isKindOfClass:[NSString class]]) {
            self.nonce = json[@"nonce"];
        }
        if (json[@"provider"] != nil && [json[@"provider"] isKindOfClass:[NSString class]]) {
            self.provider = json[@"provider"];
        }
        if (json[@"expiresOn"] != nil && [json[@"expiresOn"] isKindOfClass:[NSString class]]) {
            self.expiresOn = [(NSString *)json[@"expiresOn"] asDate];
        }
        if (json[@"isActive"] != nil && [json[@"isActive"] isKindOfClass:[NSNumber class]]) {
            self.isActive = [(NSNumber *)json[@"isActive"] boolValue];
        }
        if (json[@"deviceId"] != nil && [json[@"deviceId"] isKindOfClass:[NSString class]]) {
            self.deviceID = json[@"deviceId"];
        }
        if (json[@"platform"] != nil && [json[@"platform"] isKindOfClass:[NSString class]]) {
            self.platform = json[@"platform"];
        }
        if (json[@"platformVersion"] != nil && [json[@"platformVersion"] isKindOfClass:[NSString class]]) {
            self.platformVersion = json[@"platformVersion"];
        }
        if (json[@"sdkType"] != nil && [json[@"sdkType"] isKindOfClass:[NSString class]]) {
            self.sdkType = json[@"sdkType"];
        }
        if (json[@"sdkVersion"] != nil && [json[@"sdkVersion"] isKindOfClass:[NSString class]]) {
            self.sdkVersion = json[@"sdkVersion"];
        }
        if (json[@"profileId"] != nil && [json[@"profileId"] isKindOfClass:[NSString class]]) {
            self.profileId = json[@"profileId"];
        }
        if (json[@"sourceIp"] != nil && [json[@"sourceIp"] isKindOfClass:[NSString class]]) {
            self.sourceIP = json[@"sourceIp"];
        }
    }
    
    return self;
}

- (NSData *)encode:(NSError *__autoreleasing *)error {
    NSDictionary *dict = @{@"id" : self.id,
                           @"nonce" : self.nonce,
                           @"provider" : self.provider,
                           @"expiresOn" : [[NSDateFormatter iso8061Formatter] stringFromDate:self.expiresOn],
                           @"isActive" : [NSNumber numberWithBool:self.isActive],
                           @"deviceId" : self.deviceID,
                           @"platform" : self.platform,
                           @"platformVersion" : self.platformVersion,
                           @"sdkType" : self.sdkType,
                           @"sdkVersion" : self.sdkVersion,
                           @"profileId" : self.profileId,
                           @"sourceIp" : self.sourceIP};
    
    NSError *serializationError = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&serializationError];
    if (serializationError) {
        *error = serializationError;
        return nil;
    }
    
    return json;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.nonce forKey:@"nonce"];
    [aCoder encodeObject:self.provider forKey:@"provider"];
    [aCoder encodeObject:self.expiresOn forKey:@"expiresOn"];
    [aCoder encodeObject:self.deviceID forKey:@"deviceId"];
    [aCoder encodeObject:self.platform forKey:@"platform"];
    [aCoder encodeObject:self.platformVersion forKey:@"platformVersion"];
    [aCoder encodeObject:self.sdkType forKey:@"sdkType"];
    [aCoder encodeObject:self.profileId forKey:@"profileId"];
    [aCoder encodeObject:self.sourceIP forKey:@"sourceIp"];
    [aCoder encodeBool:self.isActive forKey:@"isActive"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.nonce = [aDecoder decodeObjectForKey:@"nonce"];
        self.provider = [aDecoder decodeObjectForKey:@"provider"];
        self.expiresOn = [aDecoder decodeObjectForKey:@"expiresOn"];
        self.deviceID = [aDecoder decodeObjectForKey:@"deviceId"];
        self.platform = [aDecoder decodeObjectForKey:@"platform"];
        self.platformVersion = [aDecoder decodeObjectForKey:@"platformVersion"];
        self.sdkType = [aDecoder decodeObjectForKey:@"sdkType"];
        self.profileId = [aDecoder decodeObjectForKey:@"profileId"];
        self.sourceIP = [aDecoder decodeObjectForKey:@"sourceIp"];
    }
    
    return self;
}

@end

