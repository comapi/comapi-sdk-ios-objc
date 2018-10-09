//
//  CMPContentUploadResult.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 09/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPContentUploadResult.h"

@implementation CMPContentUploadResult

- (instancetype)initWithID:(NSString *)ID type:(NSString *)type size:(NSNumber *)size folder:(NSString *)folder url:(NSURL *)url {
    self = [super init];
    
    if (self) {
        self.id = ID;
        self.type = type;
        self.size = size;
        self.folder = folder;
        self.url = url;
    }
    
    return self;
}

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"id"] && [JSON[@"id"] isKindOfClass:NSString.class]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"type"] && [JSON[@"type"] isKindOfClass:NSString.class]) {
            self.type = JSON[@"type"];
        }
        if (JSON[@"size"] && [JSON[@"size"] isKindOfClass:NSNumber.class]) {
            self.size = JSON[@"size"];
        }
        if (JSON[@"folder"] && [JSON[@"folder"] isKindOfClass:NSString.class]) {
            self.folder = JSON[@"folder"];
        }
        if (JSON[@"url"] && [JSON[@"url"] isKindOfClass:NSString.class]) {
            self.url = [NSURL URLWithString:JSON[@"url"]];
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
