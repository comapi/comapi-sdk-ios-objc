//
//  CMPStreamRequestTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 29/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(StreamRequestTemplate)
@protocol CMPStreamRequestTemplate

- (nullable NSInputStream *)httpBodyStream;

@end

NS_ASSUME_NONNULL_END
