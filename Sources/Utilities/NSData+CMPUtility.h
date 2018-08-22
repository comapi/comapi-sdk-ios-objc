//
//  NSData+CMPUtility.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 17/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (CMPUtility)

- (instancetype)initWithInputStream:(NSInputStream *)stream;

@end

NS_ASSUME_NONNULL_END
