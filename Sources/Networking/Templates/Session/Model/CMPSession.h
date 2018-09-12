//
//  Session.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 14/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPAuthenticationChallenge.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPSession : NSObject <NSCoding>

@property (nonatomic, nullable) NSString *id;
@property (nonatomic, nullable) NSString *nonce;
@property (nonatomic, nullable) NSString *provider;
@property (nonatomic, nullable) NSString *state;
@property (nonatomic, nullable) NSString *deviceID;
@property (nonatomic, nullable) NSString *platform;
@property (nonatomic, nullable) NSString *platformVersion;
@property (nonatomic, nullable) NSString *sdkType;
@property (nonatomic, nullable) NSString *sdkVersion;
@property (nonatomic, nullable) NSString *sourceIP;
@property (nonatomic, nullable) NSString *profileId;
@property (nonatomic, nullable) NSDate *expiresOn;
@property (nonatomic) BOOL isActive;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end

NS_ASSUME_NONNULL_END
