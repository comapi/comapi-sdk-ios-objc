//
//  CMPComapi.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPComapiClient.h"
#import "CMPComapiConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPComapi : NSObject

+ (CMPComapiClient *)initialiseWithConfig:(CMPComapiConfig *)config error:(NSError **)error;
+ (CMPComapiClient *)initialiseSharedInstanceWithConfig:(CMPComapiConfig *)config error:(NSError **)error;
+ (CMPComapiClient *)shared:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
