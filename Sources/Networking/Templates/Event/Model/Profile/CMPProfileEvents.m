//
//  CMPProfileEvents.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 11/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPProfileEvents.h"

@implementation CMPProfileEventUpdatePayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"name"] && [JSON[@"name"] isKindOfClass:NSString.class]) {
            self.name = JSON[@"name"];
        }
        if (JSON[@"eventId"] && [JSON[@"eventId"] isKindOfClass:NSString.class]) {
            self.eventID = JSON[@"eventId"];
        }
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.name forKey:@"name"];
    [dict setValue:self.eventID forKey:@"eventId"];
    
    return dict;
}

@end

@implementation CMPProfileEventUpdate

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPProfileEventUpdatePayload alloc] initWithJSON:JSON[@"payload"]];
        }
        if (JSON[@"profileId"] && [JSON[@"profileId"] isKindOfClass:NSString.class]) {
            self.profileID = JSON[@"profileId"];
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
    return [[CMPProfileEventUpdate alloc] initWithJSON:json];
}

- (id)json {
    NSMutableDictionary *dict = [super json];
    [dict setValue:[self.payload json] forKey:@"payload"];
    [dict setValue:self.profileID forKey:@"profileId"];
    
    return dict;
}

@end
