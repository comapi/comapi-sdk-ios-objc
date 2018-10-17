//
//  CMPConversationEvent.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 10/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPConversationEvents.h"
#import "NSString+CMPUtility.h"

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

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
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

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
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

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
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

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
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

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
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

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
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

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
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

@end

#pragma mark - ParticipantTyping

@implementation CMPParticipantTypingEvent

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];

    if (self) {
        if (JSON[@"accountId"] && [JSON[@"accountId"] isKindOfClass:NSDictionary.class]) {
            self.accountID = JSON[@"accountId"];
        }
        if (JSON[@"publishedOn"] && [JSON[@"publishedOn"] isKindOfClass:NSDictionary.class]) {
            self.publishedOn = JSON[@"publishedOn"];
        }
    }
    
    return self;
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

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
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

- (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [self initWithJSON:json];
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

@end
