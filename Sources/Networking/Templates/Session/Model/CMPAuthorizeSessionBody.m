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

- (nullable NSData *)encode {
    NSDictionary *dict = @{@"authenticationId" : self.authenticationID,
                           @"authenticationToken" : self.authenticationToken,
                           @"deviceId" : self.deviceID,
                           @"platform" : self.platform,
                           @"platformVersion" : self.platformVersion,
                           @"sdkType" : self.sdkType,
                           @"sdkVersion" : self.sdkVersion};
    NSError *serializationError = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&serializationError];
    if (serializationError) {
        return nil;
    }
    
    return json;
}

@end
