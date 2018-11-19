//
//  CMPMockEventDelegate.h
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 16/11/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPComapiClient.h"

NS_ASSUME_NONNULL_BEGIN

@class CMPMockEventDelegate;

@interface CMPMockEventBroadcaster : NSObject

@property (weak) CMPMockEventDelegate *delegate;

- (void)sendEvent;

@end

@interface CMPMockEventDelegate : NSObject <CMPEventDelegate>

@end

NS_ASSUME_NONNULL_END
