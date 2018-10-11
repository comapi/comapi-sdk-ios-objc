//
//  CMPEventParser.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//

#import "CMPEventParser.h"

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
    CMPEventTypeConversationMessageDelivered,
    CMPEventTypeConversationMessageSent,
    CMPEventTypeConversationMessageRead,
    CMPEventTypeProfileUpdate,
    CMPEventTypeSocketInfo
};

@interface CMPEventParser ()

+ (CMPEventType)eventTypeForName:(NSString *)name;

@end

@implementation CMPEventParser

+ (CMPEventType)eventTypeForName:(NSString *)name {
    switch (<#expression#>) {
        case <#constant#>:
            <#statements#>
            break;
            
        default:
            break;
    }
}

+ (NSArray<CMPEvent *> *)parseEvents:(NSArray<NSDictionary<NSString *,id> *> *)events {
    NSMutableArray<CMPEvent *> *parsedEvents = [NSMutableArray new];
    [events enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *eventName = [[obj[@"name"] componentsSeparatedByString:@"."] firstObject];
        
    }];

    return [NSArray arrayWithArray:parsedEvents];
}

@end
