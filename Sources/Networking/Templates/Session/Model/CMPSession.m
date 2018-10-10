//
//  Session.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 14/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSession.h"
#import "CMPUtilities.h"

@implementation CMPSession

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"id"] != nil && [JSON[@"id"] isKindOfClass:[NSString class]]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"nonce"] != nil && [JSON[@"nonce"] isKindOfClass:[NSString class]]) {
            self.nonce = JSON[@"nonce"];
        }
        if (JSON[@"provider"] != nil && [JSON[@"provider"] isKindOfClass:[NSString class]]) {
            self.provider = JSON[@"provider"];
        }
        if (JSON[@"expiresOn"] != nil && [JSON[@"expiresOn"] isKindOfClass:[NSString class]]) {
            self.expiresOn = [(NSString *)JSON[@"expiresOn"] asDate];
        }
        if (JSON[@"isActive"] != nil && [JSON[@"isActive"] isKindOfClass:[NSNumber class]]) {
            self.isActive = [(NSNumber *)JSON[@"isActive"] boolValue];
        }
        if (JSON[@"deviceId"] != nil && [JSON[@"deviceId"] isKindOfClass:[NSString class]]) {
            self.deviceID = JSON[@"deviceId"];
        }
        if (JSON[@"platform"] != nil && [JSON[@"platform"] isKindOfClass:[NSString class]]) {
            self.platform = JSON[@"platform"];
        }
        if (JSON[@"platformVersion"] != nil && [JSON[@"platformVersion"] isKindOfClass:[NSString class]]) {
            self.platformVersion = JSON[@"platformVersion"];
        }
        if (JSON[@"sdkType"] != nil && [JSON[@"sdkType"] isKindOfClass:[NSString class]]) {
            self.sdkType = JSON[@"sdkType"];
        }
        if (JSON[@"sdkVersion"] != nil && [JSON[@"sdkVersion"] isKindOfClass:[NSString class]]) {
            self.sdkVersion = JSON[@"sdkVersion"];
        }
        if (JSON[@"profileId"] != nil && [JSON[@"profileId"] isKindOfClass:[NSString class]]) {
            self.profileId = JSON[@"profileId"];
        }
        if (JSON[@"sourceIp"] != nil && [JSON[@"sourceIp"] isKindOfClass:[NSString class]]) {
            self.sourceIP = JSON[@"sourceIp"];
        }
    }
    
    return self;
}

- (NSData *)encode {
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
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&serializationError];
    if (serializationError) {
        return nil;
    }
    
    return data;
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

