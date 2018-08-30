//
//  CMPStreamRequestTemplate.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 29/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMPStreamRequestTemplate

- (nullable NSInputStream *)httpBodyStream;

@end
