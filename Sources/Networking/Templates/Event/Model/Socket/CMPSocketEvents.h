//
//  CMPSessionEvents.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 11/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPEvent.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SocketEventInfo)
@interface CMPSocketEventInfo : CMPEvent <CMPJSONDecoding, CMPJSONRepresentable>

@property (nonatomic, strong, nullable) NSString *socketID;
@property (nonatomic, strong, nullable) NSNumber *accountID;

@end

NS_ASSUME_NONNULL_END
