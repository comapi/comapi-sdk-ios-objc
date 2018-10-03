//
//  CMPRequestPerforming.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 17/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(RequestPerforming)
@protocol CMPRequestPerforming <NSObject>

- (void)performRequest:(NSURLRequest *)request completion:(void(^)(NSData * _Nullable , NSURLResponse * _Nullable, NSError * _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
