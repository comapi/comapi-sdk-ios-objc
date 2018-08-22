//
//  CMPAuthenticationDelegate.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPAuthenticationChallenge.h"
#import "CMPComapiClient.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CMPAuthenticationDelegate

- (void)client:(CMPComapiClient *)client didReceiveAuthenticationChallenge:(CMPAuthenticationChallenge *) challenge completion:(void(^)(NSString * _Nullable))continueWithToken;

@end

NS_ASSUME_NONNULL_END
