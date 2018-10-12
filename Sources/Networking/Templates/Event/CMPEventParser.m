//
//  CMPEventParser.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//

#import "CMPEventParser.h"
#import "CMPConversationMessageEvents.h"
#import "CMPConversationEvents.h"
#import "CMPProfileEvents.h"
#import "CMPSocketEvents.h"
#import "CMPLogger.h"

typedef NS_ENUM(NSUInteger, CMPEventType) {
    CMPEventTypeConversationCreate,
    CMPEventTypeConversationUpdate,
    CMPEventTypeConversationDelete,
    CMPEventTypeConversationUndelete,
    CMPEventTypeConversationParticipantAdded,
    CMPEventTypeConversationParticipantRemoved,
    CMPEventTypeConversationParticipantUpdated,
    CMPEventTypeConversationParticipantTyping,
    CMPEventTypeConversationParticipantTypingOff,
    CMPEventTypeSocketInfo,
    CMPEventTypeProfileUpdate,
    CMPEventTypeConversationMessageDelivered,
    CMPEventTypeConversationMessageSent,
    CMPEventTypeConversationMessageRead,
    CMPEventTypeNone
};

@interface CMPEventParser ()

+ (CMPEventType)eventTypeForName:(NSString *)name;

@end

@implementation CMPEventParser

+ (CMPEventType)eventTypeForName:(NSString *)name {
    NSMutableArray<NSString *> *components = [NSMutableArray arrayWithArray:[name componentsSeparatedByString:@"."]];
    if ([components count] < 2) {
        logWithLevel(CMPLogLevelError, @"Event: unknown event name:", name);
        return CMPEventTypeNone;
    }
    NSString *parentEventName = [[components firstObject] copy];
    NSString *childEventName = [[components lastObject] copy];
    
    if ([parentEventName isEqualToString:@"profile"]) {
        if ([childEventName isEqualToString:@"update"]) {
            return CMPEventTypeProfileUpdate;
        }
    } else if ([parentEventName isEqualToString:@"conversation"]) {
        if ([childEventName isEqualToString:@"create"]) {
            return CMPEventTypeConversationCreate;
        } else if ([childEventName isEqualToString:@"update"]) {
            return CMPEventTypeConversationUpdate;
        } else if ([childEventName isEqualToString:@"delete"]) {
            return CMPEventTypeConversationDelete;
        } else if ([childEventName isEqualToString:@"undelete"]) {
            return CMPEventTypeConversationUndelete;
        } else if ([childEventName isEqualToString:@"participantAdded"]) {
            return CMPEventTypeConversationParticipantAdded;
        } else if ([childEventName isEqualToString:@"participantRemoved"]) {
            return CMPEventTypeConversationParticipantRemoved;
        } else if ([childEventName isEqualToString:@"participantUpdated"]) {
            return CMPEventTypeConversationParticipantUpdated;
        } else if ([childEventName isEqualToString:@"participantTyping"]) {
            return CMPEventTypeConversationParticipantTyping;
        } else if ([childEventName isEqualToString:@"participantTypingOff"]) {
            return CMPEventTypeConversationParticipantTypingOff;
        }
    } else if ([parentEventName isEqualToString:@"socket"]) {
        if ([childEventName isEqualToString:@"info"]) {
            return CMPEventTypeSocketInfo;
        }
    } else if ([parentEventName isEqualToString:@"conversationMessage"]) {
        if ([childEventName isEqualToString:@"read"]) {
            return CMPEventTypeConversationMessageRead;
        } else if ([childEventName isEqualToString:@"sent"]) {
            return CMPEventTypeConversationMessageSent;
        } else if ([childEventName isEqualToString:@"delivered"]) {
            return CMPEventTypeConversationMessageDelivered;
        }
    }
    
    return CMPEventTypeNone;
}

+ (CMPEvent *)parseEventForData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        logWithLevel(CMPLogLevelError, @"Event: parsing error:", error.localizedDescription);
        return nil;
    }
    if ([json isKindOfClass:NSDictionary.class]) {
        switch ([CMPEventParser eventTypeForName:json[@"name"]]) {
            case CMPEventTypeConversationCreate:
                return [[CMPConversationEventCreate alloc] initWithJSON:json];
            case CMPEventTypeConversationUpdate:
                return [[CMPConversationEventUpdate alloc] initWithJSON:json];
            case CMPEventTypeConversationDelete:
                return [[CMPConversationEventDelete alloc] initWithJSON:json];
            case CMPEventTypeConversationUndelete:
                return [[CMPConversationEventUndelete alloc] initWithJSON:json];
            case CMPEventTypeConversationParticipantAdded:
                return [[CMPConversationEventParticipantAdded alloc] initWithJSON:json];
            case CMPEventTypeConversationParticipantRemoved:
                return [[CMPConversationEventParticipantRemoved alloc] initWithJSON:json];
            case CMPEventTypeConversationParticipantUpdated:
                return [[CMPConversationEventParticipantUpdated alloc] initWithJSON:json];
            case CMPEventTypeConversationParticipantTyping:
                return [[CMPConversationEventParticipantTyping alloc] initWithJSON:json];
            case CMPEventTypeConversationParticipantTypingOff:
                return [[CMPConversationEventParticipantTypingOff alloc] initWithJSON:json];
            case CMPEventTypeSocketInfo:
                return [[CMPSocketEventInfo alloc] initWithJSON:json];
            case CMPEventTypeProfileUpdate:
                return [[CMPProfileEventUpdate alloc] initWithJSON:json];
            case CMPEventTypeConversationMessageDelivered:
                return [[CMPConversationMessageEventDelivered alloc] initWithJSON:json];
            case CMPEventTypeConversationMessageSent:
                return [[CMPConversationMessageEventSent alloc] initWithJSON:json];
            case CMPEventTypeConversationMessageRead:
                return [[CMPConversationMessageEventRead alloc] initWithJSON:json];
            case CMPEventTypeNone:
                return nil;
        }
    }
    
    logWithLevel(CMPLogLevelError, @"Event: expected type: \nNSDictionary\n, got:", [json class]);
    return nil;
}

+ (NSArray<CMPEvent *> *)parseEventsForData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        logWithLevel(CMPLogLevelError, @"Event: parsing error:", error.localizedDescription);
        return @[];
    }
    NSMutableArray<CMPEvent *> *parsedEvents = [NSMutableArray new];
    if ([json isKindOfClass:NSArray.class]) {
        NSArray<NSDictionary<NSString *, id> *> *events = json;
        [events enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            switch ([CMPEventParser eventTypeForName:obj[@"name"]]) {
                case CMPEventTypeConversationCreate:
                    [parsedEvents addObject:[[CMPConversationEventCreate alloc] initWithJSON:obj]];
                    break;
                case CMPEventTypeConversationUpdate:
                    [parsedEvents addObject:[[CMPConversationEventUpdate alloc] initWithJSON:obj]];
                    break;
                case CMPEventTypeConversationDelete:
                    [parsedEvents addObject:[[CMPConversationEventDelete alloc] initWithJSON:obj]];
                    break;
                case CMPEventTypeConversationUndelete:
                    [parsedEvents addObject:[[CMPConversationEventUndelete alloc] initWithJSON:obj]];
                    break;
                case CMPEventTypeConversationParticipantAdded:
                    [parsedEvents addObject:[[CMPConversationEventParticipantAdded alloc] initWithJSON:obj]];
                    break;
                case CMPEventTypeConversationParticipantRemoved:
                    [parsedEvents addObject:[[CMPConversationEventParticipantRemoved alloc] initWithJSON:obj]];
                    break;
                case CMPEventTypeConversationParticipantUpdated:
                    [parsedEvents addObject:[[CMPConversationEventParticipantUpdated alloc] initWithJSON:obj]];
                    break;
                case CMPEventTypeConversationParticipantTyping:
                    [parsedEvents addObject:[[CMPConversationEventParticipantTyping alloc] initWithJSON:obj]];
                    break;
                case CMPEventTypeConversationParticipantTypingOff:
                    [parsedEvents addObject:[[CMPConversationEventParticipantTypingOff alloc] initWithJSON:obj]];
                    break;
                case CMPEventTypeSocketInfo:
                    [parsedEvents addObject:[[CMPSocketEventInfo alloc] initWithJSON:obj]];
                    break;
                case CMPEventTypeProfileUpdate:
                    [parsedEvents addObject:[[CMPProfileEventUpdate alloc] initWithJSON:obj]];
                    break;
                case CMPEventTypeConversationMessageDelivered:
                    [parsedEvents addObject:[[CMPConversationMessageEventDelivered alloc] initWithJSON:obj]];
                    break;
                case CMPEventTypeConversationMessageSent:
                    [parsedEvents addObject:[[CMPConversationMessageEventSent alloc] initWithJSON:obj]];
                    break;
                case CMPEventTypeConversationMessageRead:
                    [parsedEvents addObject:[[CMPConversationMessageEventRead alloc] initWithJSON:obj]];
                    break;
                case CMPEventTypeNone:
                    break;
            }
        }];
    } else {
        logWithLevel(CMPLogLevelError, @"Event: expected type: \nNSArray\n, got:", [json class]);
    }
    
    return [NSArray arrayWithArray:parsedEvents];
}

@end
