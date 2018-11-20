//
//  CMPBroadcastDelegate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 12/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(BroadcastDelegate)
@interface CMPBroadcastDelegate<__covariant Delegate> : NSObject

- (void)addDelegate:(Delegate)delegate;
- (void)removeDelegate:(Delegate)delegate;
- (void)invokeDelegatesWithBlock:(void(^)(Delegate))block;

@end

NS_ASSUME_NONNULL_END
