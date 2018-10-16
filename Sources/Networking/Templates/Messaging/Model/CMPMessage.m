//
//  CMPMessages.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMessage.h"

@implementation CMPMessage

- (instancetype)initWithID:(NSString *)ID metadata:(NSDictionary<NSString *,id> *)metadata context:(CMPMessageContext *)context parts:(NSArray<CMPMessagePart *> *)parts statusUpdates:(NSDictionary<NSString *,CMPMessageStatus *> *)statusUpdates {
    self = [super init];
    
    if (self) {
        self.id = ID;
        self.metadata = metadata;
        self.context = context;
        self.parts = parts;
        self.statusUpdates = statusUpdates;
    }
    
    return self;
}

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"id"] && [JSON[@"id"] isKindOfClass:NSString.class]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"metadata"] && [JSON[@"metadata"] isKindOfClass:NSDictionary.class]) {
            self.metadata = JSON[@"metadata"];
        }
        if (JSON[@"context"] && [JSON[@"context"] isKindOfClass:NSDictionary.class]) {
            self.context = [[CMPMessageContext alloc] initWithJSON:JSON[@"context"]];
        }
        if (JSON[@"parts"] && [JSON[@"parts"] isKindOfClass:NSArray.class]) {
            NSMutableArray<CMPMessagePart *> *parts = [NSMutableArray new];
            NSArray<NSDictionary<NSString *, id> *> *objects = JSON[@"parts"];
            [objects enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [parts addObject:[[CMPMessagePart alloc] initWithJSON:obj]];
            }];
            self.parts = [NSArray arrayWithArray:parts];
        }
        if (JSON[@"statusUpdates"] && [JSON[@"statusUpdates"] isKindOfClass:NSDictionary.class]) {
            NSMutableDictionary<NSString *, CMPMessageStatus *> *statusUpdates = [NSMutableDictionary new];
            NSDictionary<NSString *, NSDictionary<NSString *, id> *> *objects = JSON[@"statusUpdates"];
            [objects enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop) {
                statusUpdates[key] = [[CMPMessageStatus alloc] initWithJSON:obj];
            }];
            self.statusUpdates = [NSDictionary dictionaryWithDictionary:statusUpdates];
        }
    }
    
    return self;
}

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
}

@end
