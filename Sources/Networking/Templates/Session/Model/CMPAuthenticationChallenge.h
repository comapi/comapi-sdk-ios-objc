//
//  AuthenticationChallenge.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AuthenticationChallenge)
@interface CMPAuthenticationChallenge : NSObject <CMPJSONDecoding>

@property (nonatomic, strong) NSString *authenticationID;
@property (nonatomic, strong) NSString *provider;
@property (nonatomic, strong) NSString *nonce;
@property (nonatomic, strong) NSDate *expiresOn;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
