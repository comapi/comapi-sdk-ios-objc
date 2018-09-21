//
//  CMPRequestPerformer.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 17/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPRequestPerforming.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPRequestPerformer : NSObject <CMPRequestPerforming, NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURLSession *session;

@end

NS_ASSUME_NONNULL_END
