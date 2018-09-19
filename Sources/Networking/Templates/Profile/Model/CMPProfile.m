//
//  CMPProfile.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 11/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPProfile.h"
#import "NSString+CMPUtility.h"

@implementation CMPProfile

- (instancetype)initWithID:(NSString *)ID {
    self = [super init];
    
    if (self) {
        self.id = ID;
    }
    
    return self;
}

- (instancetype)initWithJSON:(NSDictionary<NSString *, id> *)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"id"] != nil && [JSON[@"id"] isKindOfClass:NSString.class]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"email"] != nil && [JSON[@"email"] isKindOfClass:NSString.class]) {
            self.email = JSON[@"email"];
        }
        if (JSON[@"_createdOn"] != nil && [JSON[@"_createdOn"] isKindOfClass:NSString.class]) {
            self.createdOn = [(NSString *)JSON[@"_createdOn"] asDate];
        }
        if (JSON[@"_createdBy"] != nil && [JSON[@"_createdBy"] isKindOfClass:NSString.class]) {
            self.createdBy = JSON[@"_createdBy"];
        }
        if (JSON[@"_updatedOn"] != nil && [JSON[@"_updatedOn"] isKindOfClass:NSString.class]) {
            self.updatedOn = [(NSString *)JSON[@"_updatedOn"] asDate];
        }
        if (JSON[@"_updatedBy"] != nil && [JSON[@"_updatedBy"] isKindOfClass:NSString.class]) {
            self.updatedBy = JSON[@"_updatedBy"];
        }
    }
    
    return self;
}

- (instancetype)decodeWithData:(NSData *)data error:(NSError *__autoreleasing *)error {
    NSError *serializationError = nil;
    NSDictionary<NSString *, id> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
    if (serializationError) {
        *error = serializationError;
        return nil;
    }
    return [self initWithJSON:json];
}

@end
