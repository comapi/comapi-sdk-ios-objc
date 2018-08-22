//
//  CMPRequestPerformer.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 17/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPRequestTemplate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPRequestPerformer : NSObject <NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURLSession *session;

- (void)performRequest:(NSURLRequest *)request completion:(void(^)(NSData * _Nullable , NSURLResponse * _Nullable, NSError * _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
