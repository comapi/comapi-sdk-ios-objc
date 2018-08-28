//
//  CMPAuthorizeSessionBody.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 27/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAuthorizeSessionBody.h"
#import "CMPConstants.h"
#import <UIKit/UIKit.h>

@implementation CMPAuthorizeSessionBody

-(instancetype)initWithAuthenticationID:(NSString *)authenticationID authenticationToken:(NSString *)authenticationToken {
    self = [super init];
    
    if (self) {
        self.authenticationID = authenticationID;
        self.authenticationToken = authenticationToken;
        self.deviceID = [[UIDevice currentDevice] model];
        self.platform = CMPPlatformInfo;
        self.platformVersion = [[UIDevice currentDevice] systemVersion];
        self.sdkType = CMPSDKType;
        self.sdkVersion = CMPSDKVersion;
    }
    
    return self;
}

-(instancetype)initWithAuthenticationID:(NSString *)authenticationID authenticationToken:(NSString *)authenticationToken deviceID:(NSString *)deviceID platform:(NSString *)platform platformVersion:(NSString *)platformVersion sdkType:(NSString *)sdkType sdkVersion:(NSString *)sdkVersion {
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

@end
