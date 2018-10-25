//
//  CMPConversationEvent.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 10/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPConversationEvents.h"
#import "NSString+CMPUtility.h"
#import "NSDateFormatter+CMPUtility.h"

#pragma mark - Conversation

@implementation CMPConversationEvent

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
        if (JSON[@"conversationEventId"] && [JSON[@"conversationEventId"] isKindOfClass:NSString.class]) {
            self.conversationEventID = JSON[@"conversationEventId"];
        }
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [super json];
    [dict setValue:self.conversationID forKey:@"conversationId"];
    [dict setValue:self.conversationEventID forKey:@"conversationEventId"];
    
    return dict;
}

@end

#pragma mark - Create

@implementation CMPConversationEventCreate

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationEventCreatePayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPConversationEventCreate alloc] initWithJSON:json];
}

- (id)json {
    NSMutableDictionary *dict = [super json];
    [dict setValue:[self.payload json] forKey:@"payload"];
    
    return dict;
}

@end

@implementation CMPConversationEventCreatePayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"id"] && [JSON[@"id"] isKindOfClass:NSString.class]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"name"] && [JSON[@"name"] isKindOfClass:NSString.class]) {
            self.name = JSON[@"name"];
        }
        if (JSON[@"isPublic"] && [JSON[@"isPublic"] isKindOfClass:NSNumber.class]) {
            self.isPublic = JSON[@"isPublic"];
        }
        if (JSON[@"roles"] && [JSON[@"roles"] isKindOfClass:NSDictionary.class]) {
            self.roles = [[CMPRoles alloc] initWithJSON:JSON[@"roles"]];
        }
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSArray.class]) {
            NSMutableArray<CMPConversationParticipant *> *participants = [NSMutableArray new];
            NSArray<NSDictionary *> *objects = JSON[@"participants"];
            [objects enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [participants addObject:[[CMPConversationParticipant alloc] initWithJSON:obj]];
            }];
            self.participants = participants;
        }
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.id forKey:@"id"];
    [dict setValue:self.name forKey:@"name"];
    [dict setValue:self.isPublic forKey:@"isPublic"];
    [dict setValue:[self.roles json] forKey:@"roles"];
    NSMutableArray<NSDictionary<NSString *, id> *> *participants = [NSMutableArray new];
    [self.participants enumerateObjectsUsingBlock:^(CMPConversationParticipant * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [participants addObject:[obj json]];
    }];
    [dict setValue:participants forKey:@"participants"];
    
    return dict;
}

@end

#pragma mark - Update

@implementation CMPConversationEventUpdate

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationEventUpdatePayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPConversationEventUpdate alloc] initWithJSON:json];
}

- (id)json {
    NSMutableDictionary *dict = [super json];
    [dict setValue:[self.payload json] forKey:@"payload"];
    
    return dict;
}

@end

@implementation CMPConversationEventUpdatePayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];

    if (self) {
        if (JSON[@"id"] && [JSON[@"id"] isKindOfClass:NSString.class]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"name"] && [JSON[@"name"] isKindOfClass:NSString.class]) {
            self.name = JSON[@"name"];
        }
        if (JSON[@"isPublic"] && [JSON[@"isPublic"] isKindOfClass:NSNumber.class]) {
            self.isPublic = JSON[@"isPublic"];
        }
        if (JSON[@"roles"] && [JSON[@"roles"] isKindOfClass:NSDictionary.class]) {
            self.roles = [[CMPRoles alloc] initWithJSON:JSON[@"roles"]];
        }
        if (JSON[@"description"] && [JSON[@"description"] isKindOfClass:NSString.class]) {
            self.eventDescription = JSON[@"description"];
        }
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.id forKey:@"id"];
    [dict setValue:self.name forKey:@"name"];
    [dict setValue:self.isPublic forKey:@"isPublic"];
    [dict setValue:[self.roles json] forKey:@"roles"];
    [dict setValue:self.eventDescription forKey:@"description"];
    
    return dict;
}

@end

#pragma mark - Delete

@implementation CMPConversationEventDelete

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationEventDeletePayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPConversationEventDelete alloc] initWithJSON:json];
}

- (id)json {
    NSMutableDictionary *dict = [super json];
    [dict setValue:[self.payload json] forKey:@"payload"];
    
    return dict;
}

@end

@implementation CMPConversationEventDeletePayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"date"] && [JSON[@"date"] isKindOfClass:NSString.class]) {
            self.date = [(NSString *)JSON[@"date"] asDate];
        }
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:[[NSDateFormatter comapiFormatter] stringFromDate:self.date] forKey:@"date"];
    
    return dict;
}

@end

#pragma mark - Undelete

@implementation CMPConversationEventUndelete

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationEventUndeletePayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPConversationEventUndelete alloc] initWithJSON:json];
}

- (id)json {
    NSMutableDictionary *dict = [super json];
    [dict setValue:[self.payload json] forKey:@"payload"];
    
    return dict;
}

@end

@implementation CMPConversationEventUndeletePayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];

    if (self) {
        if (JSON[@"id"] && [JSON[@"id"] isKindOfClass:NSString.class]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"name"] && [JSON[@"name"] isKindOfClass:NSString.class]) {
            self.name = JSON[@"name"];
        }
        if (JSON[@"isPublic"] && [JSON[@"isPublic"] isKindOfClass:NSNumber.class]) {
            self.isPublic = JSON[@"isPublic"];
        }
        if (JSON[@"roles"] && [JSON[@"roles"] isKindOfClass:NSDictionary.class]) {
            self.roles = [[CMPRoles alloc] initWithJSON:JSON[@"roles"]];
        }
        if (JSON[@"description"] && [JSON[@"description"] isKindOfClass:NSString.class]) {
            self.eventDescription = JSON[@"description"];
        }
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.id forKey:@"id"];
    [dict setValue:self.name forKey:@"name"];
    [dict setValue:self.isPublic forKey:@"isPublic"];
    [dict setValue:[self.roles json] forKey:@"roles"];
    [dict setValue:self.eventDescription forKey:@"description"];
    
    return dict;
}

@end

#pragma mark - ParticipantAdded

@implementation CMPConversationEventParticipantAdded

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationEventParticipantAddedPayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPConversationEventParticipantAdded alloc] initWithJSON:json];
}

- (id)json {
    NSMutableDictionary *dict = [super json];
    [dict setValue:[self.payload json] forKey:@"payload"];
    
    return dict;
}

@end

@implementation CMPConversationEventParticipantAddedPayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];

    if (self) {
        if (JSON[@"apiSpaceId"] && [JSON[@"apiSpaceId"] isKindOfClass:NSString.class]) {
            self.apiSpaceID = JSON[@"apiSpaceId"];
        }
        if (JSON[@"profileId"] && [JSON[@"profileId"] isKindOfClass:NSString.class]) {
            self.profileID = JSON[@"profileId"];
        }
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
        if (JSON[@"role"] && [JSON[@"role"] isKindOfClass:NSString.class]) {
            self.role = JSON[@"role"];
        }
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.apiSpaceID forKey:@"apiSpaceId"];
    [dict setValue:self.profileID forKey:@"profileId"];
    [dict setValue:self.conversationID forKey:@"conversationId"];
    [dict setValue:self.role forKey:@"role"];
    
    return dict;
}

@end

#pragma mark - ParticipantRemoved

@implementation CMPConversationEventParticipantRemoved

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationEventParticipantRemovedPayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPConversationEventParticipantRemoved alloc] initWithJSON:json];
}

- (id)json {
    NSMutableDictionary *dict = [super json];
    [dict setValue:[self.payload json] forKey:@"payload"];
    
    return dict;
}

@end

@implementation CMPConversationEventParticipantRemovedPayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"apiSpaceId"] && [JSON[@"apiSpaceId"] isKindOfClass:NSString.class]) {
            self.apiSpaceID = JSON[@"apiSpaceId"];
        }
        if (JSON[@"profileId"] && [JSON[@"profileId"] isKindOfClass:NSString.class]) {
            self.profileID = JSON[@"profileId"];
        }
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.apiSpaceID forKey:@"apiSpaceId"];
    [dict setValue:self.profileID forKey:@"profileId"];
    [dict setValue:self.conversationID forKey:@"conversationId"];
    
    return dict;
}

@end

#pragma mark - ParticipantUpdated

@implementation CMPConversationEventParticipantUpdated

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationEventParticipantUpdatedPayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPConversationEventParticipantUpdated alloc] initWithJSON:json];
}

- (id)json {
    NSMutableDictionary *dict = [super json];
    [dict setValue:[self.payload json] forKey:@"payload"];
    
    return dict;
}

@end

@implementation CMPConversationEventParticipantUpdatedPayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"apiSpaceId"] && [JSON[@"apiSpaceId"] isKindOfClass:NSString.class]) {
            self.apiSpaceID = JSON[@"apiSpaceId"];
        }
        if (JSON[@"profileId"] && [JSON[@"profileId"] isKindOfClass:NSString.class]) {
            self.profileID = JSON[@"profileId"];
        }
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
        if (JSON[@"role"] && [JSON[@"role"] isKindOfClass:NSString.class]) {
            self.role = JSON[@"role"];
        }
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.apiSpaceID forKey:@"apiSpaceId"];
    [dict setValue:self.profileID forKey:@"profileId"];
    [dict setValue:self.conversationID forKey:@"conversationId"];
    [dict setValue:self.role forKey:@"role"];
    
    return dict;
}

@end

#pragma mark - ParticipantTyping

@implementation CMPParticipantTypingEvent

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];

    if (self) {
        if (JSON[@"accountId"] && [JSON[@"accountId"] isKindOfClass:NSString.class]) {
            self.accountID = JSON[@"accountId"];
        }
        if (JSON[@"publishedOn"] && [JSON[@"publishedOn"] isKindOfClass:NSString.class]) {
            self.publishedOn = [(NSString *)JSON[@"publishedOn"] asDate];
        }
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [super json];
    [dict setValue:self.accountID forKey:@"accountId"];
    [dict setValue:[[NSDateFormatter comapiFormatter] stringFromDate:self.publishedOn] forKey:@"publishedOn"];
    
    return dict;
}

@end

#pragma mark - ParticipantTypingOn

@implementation CMPConversationEventParticipantTyping

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationEventParticipantTypingPayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPConversationEventParticipantTyping alloc] initWithJSON:json];
}

- (id)json {
    NSMutableDictionary *dict = [super json];
    [dict setValue:[self.payload json] forKey:@"payload"];
    
    return dict;
}

@end

@implementation CMPConversationEventParticipantTypingPayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"profileId"] && [JSON[@"profileId"] isKindOfClass:NSString.class]) {
            self.profileID = JSON[@"profileId"];
        }
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.profileID forKey:@"profileId"];
    [dict setValue:self.conversationID forKey:@"conversationId"];
    
    return dict;
}

@end

#pragma mark - ParticipantTypingOff

@implementation CMPConversationEventParticipantTypingOff

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationEventParticipantTypingOffPayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPConversationEventParticipantTypingOff alloc] initWithJSON:json];
}

- (id)json {
    NSMutableDictionary *dict = [super json];
    [dict setValue:[self.payload json] forKey:@"payload"];
    
    return dict;
}

@end

@implementation CMPConversationEventParticipantTypingOffPayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"profileId"] && [JSON[@"profileId"] isKindOfClass:NSString.class]) {
            self.profileID = JSON[@"profileId"];
        }
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.profileID forKey:@"profileId"];
    [dict setValue:self.conversationID forKey:@"conversationId"];
    
    return dict;
}

@end
