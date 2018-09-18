//
//  CMPAuthenticationDelegate.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAuthenticationChallenge.h"

@class CMPComapiClient;

NS_ASSUME_NONNULL_BEGIN

@protocol CMPAuthenticationDelegate <NSObject>

- (void)clientWith:(CMPComapiClient *)client didReceiveAuthenticationChallenge:(CMPAuthenticationChallenge *)challenge completion:(void(^)(NSString * _Nullable))continueWithToken;

@end

NS_ASSUME_NONNULL_END
