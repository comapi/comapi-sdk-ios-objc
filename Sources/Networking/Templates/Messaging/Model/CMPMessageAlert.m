//
//  CMPMessageAlert.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMessageAlert.h"

@implementation CMPMessageAlert

- (instancetype)initWithPlatforms:(CMPMessageAlertPlatforms *)platforms {
    self = [super init];
    
    if (self) {
        self.platforms = platforms;
    }
    
    return self;
}

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"platforms"] && [JSON[@"platforms"] isKindOfClass:NSDictionary.class]) {
            self.platforms = [[CMPMessageAlertPlatforms alloc] initWithJSON:JSON[@"platforms"]];
        }
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:[self.platforms json] forKey:@"platforms"];
    
    return dict;
}

- (NSData *)encode {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self json] options:0 error:&error];
    if (error) {
        return nil;
    }
    return data;
}

@end
