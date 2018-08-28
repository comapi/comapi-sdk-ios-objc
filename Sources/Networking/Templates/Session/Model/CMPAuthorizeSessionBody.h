//
//  CMPAuthorizeSessionBody.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 27/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMPAuthorizeSessionBody : NSObject

@property (nonatomic, strong) NSString *authenticationID;
@property (nonatomic, strong) NSString *authenticationToken;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *platform;
@property (nonatomic, strong) NSString *platformVersion;
@property (nonatomic, strong) NSString *sdkType;
@property (nonatomic, strong) NSString *sdkVersion;

- (instancetype)initWithAuthenticationID:(NSString *)authenticationID authenticationToken:(NSString *)authenticationToken;
- (instancetype)initWithAuthenticationID:(NSString *)authenticationID authenticationToken:(NSString *)authenticationToken deviceID:(NSString *)deviceID platform:(NSString *)platform platformVersion:(NSString *)platformVersion sdkType:(NSString *)sdkType sdkVersion:(NSString *)sdkVersion;

@end

NS_ASSUME_NONNULL_END
