//
//  CMPMessagePart.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMessagePart.h"

@implementation CMPMessagePart

- (instancetype)initWithName:(NSString *)name type:(NSString *)type url:(NSURL *)url data:(NSString *)data size:(NSNumber *)size {
    self = [super init];
    
    if (self) {
        self.name = name;
        self.type = type;
        self.url = url;
        self.data = data;
        self.size = size;
    }
    
    return self;
}

#pragma mark - CMPJSONEncoding

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.name forKey:@"name"];
    [dict setValue:self.type forKey:@"type"];
    [dict setValue:self.data forKey:@"data"];
    [dict setValue:[self.url absoluteString] forKey:@"url"];
    [dict setValue:self.size forKey:@"size"];
    
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

#pragma mark - CMPJSONDecoding

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"name"] && [JSON[@"name"] isKindOfClass:NSString.class]) {
            self.name = JSON[@"name"];
        }
        if (JSON[@"type"] && [JSON[@"type"] isKindOfClass:NSString.class]) {
            self.type = JSON[@"type"];
        }
        if (JSON[@"data"] && [JSON[@"data"] isKindOfClass:NSString.class]) {
            self.data = JSON[@"data"];
        }
        if (JSON[@"url"] && [JSON[@"url"] isKindOfClass:NSString.class]) {
            self.url = [[NSURL alloc] initWithString:JSON[@"url"]];
        }
        if (JSON[@"size"] && [JSON[@"size"] isKindOfClass:NSNumber.class]) {
            self.size = JSON[@"size"];
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
    return [[CMPMessagePart alloc] initWithJSON:json];
}



@end
