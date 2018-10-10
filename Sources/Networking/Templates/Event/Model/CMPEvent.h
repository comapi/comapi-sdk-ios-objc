//
//  CMPEvent.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 03/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONDecoding.h"

@class CMPEventContext;

NS_ASSUME_NONNULL_BEGIN

@interface CMPEvent : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *eventID;
@property (nonatomic, strong, nullable) NSString *apiSpaceID;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) CMPEventContext *context;

@end

@interface CMPEventContext : NSObject <CMPJSONDecoding>

@property (nonatomic, strong) NSString *createdBy;

@end

NS_ASSUME_NONNULL_END
