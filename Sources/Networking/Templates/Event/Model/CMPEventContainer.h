//
//  CMPEventContainer.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 03/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPEventContainer : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) CMPEvent *event;

@end

NS_ASSUME_NONNULL_END
