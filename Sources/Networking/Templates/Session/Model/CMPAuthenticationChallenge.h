//
//  AuthenticationChallenge.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPAuthenticationChallenge : NSObject <CMPJSONDecoding>

@property (nonatomic, strong) NSString *authenticationID;
@property (nonatomic, strong) NSString *provider;
@property (nonatomic, strong) NSString *nonce;
@property (nonatomic, strong) NSDate *expiresOn;

@end

NS_ASSUME_NONNULL_END
