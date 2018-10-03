//
//  CMPAuthorizeSessionBody.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 27/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONEncoding.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AuthorizeSessionBody)
@interface CMPAuthorizeSessionBody : NSObject <CMPJSONEncoding>

@property (nonatomic, strong) NSString *authenticationID;
@property (nonatomic, strong) NSString *authenticationToken;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *platform;
@property (nonatomic, strong) NSString *platformVersion;
@property (nonatomic, strong) NSString *sdkType;
@property (nonatomic, strong) NSString *sdkVersion;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAuthenticationID:(NSString *)authenticationID authenticationToken:(NSString *)authenticationToken;
- (instancetype)initWithAuthenticationID:(NSString *)authenticationID authenticationToken:(NSString *)authenticationToken deviceID:(NSString *)deviceID platform:(NSString *)platform platformVersion:(NSString *)platformVersion sdkType:(NSString *)sdkType sdkVersion:(NSString *)sdkVersion;

@end

NS_ASSUME_NONNULL_END
