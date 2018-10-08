//
//  CMPProfile.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 11/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPProfile.h"
#import "CMPUtilities.h"

@implementation CMPProfile

- (instancetype)initWithID:(NSString *)ID {
    self = [super init];
    
    if (self) {
        self.id = ID;
    }
    
    return self;
}

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"id"] != nil && [JSON[@"id"] isKindOfClass:NSString.class]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"email"] != nil && [JSON[@"email"] isKindOfClass:NSString.class]) {
            self.email = JSON[@"email"];
        }
    }
    
    return self;
}

- (instancetype)decodeWithData:(NSData *)data {
    NSError *serializationError = nil;
    NSDictionary<NSString *, id> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
    if (serializationError) {
        return nil;
    }
    return [self initWithJSON:json];
}

@end
