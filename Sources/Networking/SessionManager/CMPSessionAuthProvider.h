//
//  CMPSessionAuthProvider.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 29/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMPSessionAuthProvider

- (void)authenticateWithSuccess:(void(^ _Nullable)(void))success failure:(void(^ _Nullable)(NSError *))failure;

@end
