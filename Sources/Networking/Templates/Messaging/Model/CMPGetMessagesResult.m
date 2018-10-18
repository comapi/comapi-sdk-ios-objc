//
//  CMPGetMessagesResult.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPGetMessagesResult.h"

@implementation CMPGetMessagesResult

- (instancetype)initWithLatestEventID:(NSNumber *)latestEventID earliestEventID:(NSNumber *)earliestEventID messages:(NSArray<CMPMessage *> *)messages orphanedEvents:(NSArray<CMPOrphanedEvent *> *)orphanedEvents {
    self = [super init];
    
    if (self) {
        self.latestEventID = latestEventID;
        self.earliestEventID = earliestEventID;
        self.messages = messages;
        self.orphanedEvents = orphanedEvents;
    }
    
    return self;
}

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"latestEventId"] && [JSON[@"latestEventId"] isKindOfClass:NSNumber.class]) {
            self.latestEventID = JSON[@"latestEventId"];
        }
        if (JSON[@"earliestEventId"] && [JSON[@"earliestEventId"] isKindOfClass:NSNumber.class]) {
            self.earliestEventID = JSON[@"earliestEventId"];
        }
        if (JSON[@"messages"] && [JSON[@"messages"] isKindOfClass:NSArray.class]) {
            NSMutableArray<CMPMessage *> *messages = [NSMutableArray new];
            NSArray<NSDictionary<NSString *, id> *> *objects = JSON[@"messages"];
            [objects enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [messages addObject:[[CMPMessage alloc] initWithJSON:obj]];
            }];
            self.messages = messages;
        }
        if (JSON[@"orphanedEvents"] && [JSON[@"orphanedEvents"] isKindOfClass:NSArray.class]) {
            NSMutableArray<CMPOrphanedEvent *> *events = [NSMutableArray new];
            NSArray<NSDictionary<NSString *, id> *> *objects = JSON[@"orphanedEvents"];
            [objects enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [events addObject:[[CMPOrphanedEvent alloc] initWithJSON:obj]];
            }];
            self.orphanedEvents = events;
        }
    }
    
    return self;
}

- (nullable instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
}

@end
