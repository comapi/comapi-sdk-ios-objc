//
//  CMPConversationMessageEvents.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 11/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPConversationMessageEvents.h"
#import "NSString+CMPUtility.h"

#pragma mark - ConversationMessage

@implementation CMPConversationMessageEvent

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"conversationEventId"] && [JSON[@"conversationEventId"] isKindOfClass:NSString.class]) {
            self.conversationEventID = JSON[@"conversationEventId"];
        }
    }
    
    return self;
}

@end

#pragma mark - Delivered

@implementation CMPConversationMessageEventDeliveredPayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];

    if (self) {
        if (JSON[@"messageId"] && [JSON[@"messageId"] isKindOfClass:NSString.class]) {
            self.messageID = JSON[@"messageId"];
        }
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
        if (JSON[@"profileId"] && [JSON[@"profileId"] isKindOfClass:NSString.class]) {
            self.profileID = JSON[@"profileId"];
        }
        if (JSON[@"timestamp"] && [JSON[@"timestamp"] isKindOfClass:NSString.class]) {
            self.timestamp = [(NSString *)JSON[@"timestamp"] asDate];
        }
    }
    
    return self;
}

@end

@implementation CMPConversationMessageEventDelivered

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];

    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSString.class]) {
            self.payload = [[CMPConversationMessageEventDeliveredPayload alloc] initWithJSON:JSON[@"payload"]];
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

#pragma mark - Read

@implementation CMPConversationMessageEventReadPayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"messageId"] && [JSON[@"messageId"] isKindOfClass:NSString.class]) {
            self.messageID = JSON[@"messageId"];
        }
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
        if (JSON[@"profileId"] && [JSON[@"profileId"] isKindOfClass:NSString.class]) {
            self.profileID = JSON[@"profileId"];
        }
        if (JSON[@"timestamp"] && [JSON[@"timestamp"] isKindOfClass:NSString.class]) {
            self.timestamp = [(NSString *)JSON[@"timestamp"] asDate];
        }
    }
    
    return self;
}

@end

@implementation CMPConversationMessageEventRead

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSString.class]) {
            self.payload = [[CMPConversationMessageEventReadPayload alloc] initWithJSON:JSON[@"payload"]];
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

#pragma mark - Sent

@implementation CMPConversationMessageEventSentPayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"messageId"] && [JSON[@"messageId"] isKindOfClass:NSString.class]) {
            self.messageID = JSON[@"messageId"];
        }
        if (JSON[@"metadata"] && [JSON[@"metadata"] isKindOfClass:NSDictionary.class]) {
            self.metadata = JSON[@"metadata"];
        }
        if (JSON[@"context"] && [JSON[@"context"] isKindOfClass:NSDictionary.class]) {
            self.context = [[CMPMessageContext alloc] initWithJSON:JSON[@"context"]];
        }
        if (JSON[@"alert"] && [JSON[@"alert"] isKindOfClass:NSString.class]) {
            self.alert = [[CMPMessageAlert alloc] initWithJSON:JSON[@"alert"]];
        }
        if (JSON[@"parts"] && [JSON[@"parts"] isKindOfClass:NSArray.class]) {
            NSMutableArray<CMPMessagePart *> *parts = [NSMutableArray new];
            NSArray<NSDictionary<NSString *, id> *> *objects = JSON[@"parts"];
            [objects enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [parts addObject:[[CMPMessagePart alloc] initWithJSON:obj]];
            }];
            self.parts = parts;
        }
    }
    
    return self;
}

@end

@implementation CMPConversationMessageEventSent

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSString.class]) {
            self.payload = [[CMPConversationMessageEventSentPayload alloc] initWithJSON:JSON[@"payload"]];
        }
        if (JSON[@"publishedOn"] && [JSON[@"publishedOn"] isKindOfClass:NSString.class]) {
            self.publishedOn = [(NSString *)JSON[@"payload"] asDate];
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
