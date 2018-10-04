//
//  CMPEvent.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 03/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMPEvent : NSObject

@end

@interface CMPEventContext : NSObject

@property (nonatomic, strong) NSString *createdBy;

@end

NS_ASSUME_NONNULL_END
