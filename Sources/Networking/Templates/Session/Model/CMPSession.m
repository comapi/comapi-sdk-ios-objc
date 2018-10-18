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
            self.isActive = JSON[@"isActive"];
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
            self.profileID = JSON[@"profileId"];
        }
        if (JSON[@"sourceIp"] != nil && [JSON[@"sourceIp"] isKindOfClass:[NSString class]]) {
            self.sourceIP = JSON[@"sourceIp"];
        }
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.id forKey:@"id"];
    [dict setValue:self.nonce forKey:@"nonce"];
    [dict setValue:self.provider forKey:@"provider"];
    [dict setValue:[[NSDateFormatter iso8061Formatter] stringFromDate:self.expiresOn] forKey:@"expiresOn"];
    [dict setValue:self.isActive forKey:@"isActive"];
    [dict setValue:self.platform forKey:@"platform"];
    [dict setValue:self.platformVersion forKey:@"platformVersion"];
    [dict setValue:self.sdkType forKey:@"sdkType"];
    [dict setValue:self.sdkVersion forKey:@"sdkVersion"];
    [dict setValue:self.profileID forKey:@"profileId"];
    [dict setValue:self.deviceID forKey:@"deviceId"];
    [dict setValue:self.sourceIP forKey:@"sourceIp"];
    
    return dict;
}

- (NSData *)encode {    
    NSError *serializationError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self json] options:0 error:&serializationError];
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
    [aCoder encodeObject:self.profileID forKey:@"profileId"];
    [aCoder encodeObject:self.sourceIP forKey:@"sourceIp"];
    [aCoder encodeObject:self.isActive forKey:@"isActive"];
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
        self.profileID = [aDecoder decodeObjectForKey:@"profileId"];
        self.sourceIP = [aDecoder decodeObjectForKey:@"sourceIp"];
        self.isActive = [aDecoder decodeObjectForKey:@"isActive"];
    }
    
    return self;
}

@end

