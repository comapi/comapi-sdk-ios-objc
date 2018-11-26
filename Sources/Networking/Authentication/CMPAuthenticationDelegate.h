//
//  CMPAuthenticationDelegate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAuthenticationChallenge.h"

@class CMPComapiClient;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AuthenticationDelegate)
@protocol CMPAuthenticationDelegate <NSObject>

- (void)client:(CMPComapiClient *)client didReceiveAuthenticationChallenge:(CMPAuthenticationChallenge *)challenge completion:(void(^)(NSString * _Nullable))continueWithToken;

@end

NS_ASSUME_NONNULL_END
