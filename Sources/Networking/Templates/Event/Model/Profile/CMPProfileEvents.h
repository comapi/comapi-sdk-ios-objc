//
//  CMPProfileEvents.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 11/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPProfileEventUpdatePayload : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *eventID;
@property (nonatomic, strong, nullable) NSString *name;

@end

@interface CMPProfileEventUpdate : CMPEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) CMPProfileEventUpdatePayload *payload;

@end

NS_ASSUME_NONNULL_END
