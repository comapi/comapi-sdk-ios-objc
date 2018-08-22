//
//  Session.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 14/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSession.h"
#import "NSString+CMPUtility.h"

@implementation CMPSession

- (instancetype)initWithJSON:(NSDictionary *)json {
    CMPSession* session = [[CMPSession alloc] init];
    
    if (json[@"id"] != nil && [json[@"id"] isKindOfClass:[NSString class]]) {
        session.id = json[@"id"];
    }
    if (json[@"nonce"] != nil && [json[@"nonce"] isKindOfClass:[NSString class]]) {
        session.nonce = json[@"nonce"];
    }
    if (json[@"provider"] != nil && [json[@"provider"] isKindOfClass:[NSString class]]) {
        session.provider = json[@"provider"];
    }
    if (json[@"expiresOn"] != nil && [json[@"expiresOn"] isKindOfClass:[NSString class]]) {
        session.expiresOn = [(NSString*)json[@"expiresOn"] asDate];
    }
    if (json[@"isActive"] != nil && [json[@"isActive"] isKindOfClass:[NSNumber class]]) {
        session.isActive = [(NSNumber*)json[@"isActive"] boolValue];
    }
    if (json[@"deviceID"] != nil && [json[@"deviceID"] isKindOfClass:[NSString class]]) {
        session.deviceID = json[@"deviceID"];
    }
    if (json[@"platform"] != nil && [json[@"platform"] isKindOfClass:[NSString class]]) {
        session.platform = json[@"platform"];
    }
    if (json[@"platformVersion"] != nil && [json[@"platformVersion"] isKindOfClass:[NSString class]]) {
        session.platformVersion = json[@"platformVersion"];
    }
    if (json[@"sdkType"] != nil && [json[@"sdkType"] isKindOfClass:[NSString class]]) {
        session.sdkType = json[@"sdkType"];
    }
    if (json[@"sdkVersion"] != nil && [json[@"sdkVersion"] isKindOfClass:[NSString class]]) {
        session.sdkVersion = json[@"sdkVersion"];
    }
    if (json[@"profileId"] != nil && [json[@"profileId"] isKindOfClass:[NSString class]]) {
        session.profileId = json[@"profileId"];
    }
    if (json[@"sourceIP"] != nil && [json[@"sourceIP"] isKindOfClass:[NSString class]]) {
        session.sourceIP = json[@"sourceIP"];
    }
    
    return session;
}

@end

