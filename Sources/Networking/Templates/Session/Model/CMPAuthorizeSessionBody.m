//
//  CMPAuthorizeSessionBody.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 27/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAuthorizeSessionBody.h"
#import <UIKit/UIKit.h>
#import "CMPUtilities.h"

@implementation CMPAuthorizeSessionBody

- (instancetype)initWithAuthenticationID:(NSString *)authenticationID authenticationToken:(NSString *)authenticationToken {
    self = [super init];
    
    if (self) {
        self.authenticationID = authenticationID;
        self.authenticationToken = authenticationToken;
        self.deviceID = [[UIDevice currentDevice] model];
        self.platform = CMPSDKInfoPlatform;
        self.platformVersion = [[UIDevice currentDevice] systemVersion];
        self.sdkType = CMPSDKInfoType;
        self.sdkVersion = CMPSDKInfoVersion;
    }
    
    return self;
}

- (instancetype)initWithAuthenticationID:(NSString *)authenticationID authenticationToken:(NSString *)authenticationToken deviceID:(NSString *)deviceID platform:(NSString *)platform platformVersion:(NSString *)platformVersion sdkType:(NSString *)sdkType sdkVersion:(NSString *)sdkVersion {
    self = [super init];
    
    if (self) {
        self.authenticationID = authenticationID;
        self.authenticationToken = authenticationToken;
        self.deviceID = deviceID;
        self.platform = platform;
        self.platformVersion = platformVersion;
        self.sdkType = sdkType;
        self.sdkVersion = sdkVersion;
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.authenticationID forKey:@"authenticationId"];
    [dict setValue:self.authenticationToken forKey:@"authenticationToken"];
    [dict setValue:self.deviceID forKey:@"deviceId"];
    [dict setValue:self.platform forKey:@"platform"];
    [dict setValue:self.platformVersion forKey:@"platformVersion"];
    [dict setValue:self.sdkType forKey:@"sdkType"];
    [dict setValue:self.sdkVersion forKey:@"sdkVersion"];
    
    return dict;
}

- (nullable NSData *)encode {
    NSError *serializationError = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:[self json] options:0 error:&serializationError];
    if (serializationError) {
        return nil;
    }
    
    return json;
}

@end
