//
//  CMPGetMessagesResult.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMessage.h"
#import "CMPOrphanedEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPGetMessagesResult : NSObject <CMPJSONDecoding, CMPJSONRepresentable>

@property (nonatomic, strong, nullable) NSNumber *latestEventID;
@property (nonatomic, strong, nullable) NSNumber *earliestEventID;
@property (nonatomic, strong, nullable) NSArray<CMPMessage *> *messages;
@property (nonatomic, strong, nullable) NSArray<CMPOrphanedEvent *> *orphanedEvents;

- (instancetype)initWithLatestEventID:(nullable NSNumber *)latestEventID earliestEventID:(nullable NSNumber *)earliestEventID messages:(nullable NSArray<CMPMessage *> *)messages orphanedEvents:(nullable NSArray<CMPOrphanedEvent *> *)orphanedEvents;

@end

NS_ASSUME_NONNULL_END
