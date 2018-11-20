//
//  CMPProfileEvents.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 11/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPEvent.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ProfileEventUpdatePayload)
@interface CMPProfileEventUpdatePayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSString *eventID;
@property (nonatomic, strong, nullable) NSString *name;

@end

NS_SWIFT_NAME(ProfileEventUpdate)
@interface CMPProfileEventUpdate : CMPEvent <CMPJSONDecoding, CMPJSONRepresentable>

@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) CMPProfileEventUpdatePayload *payload;

@end

NS_ASSUME_NONNULL_END
