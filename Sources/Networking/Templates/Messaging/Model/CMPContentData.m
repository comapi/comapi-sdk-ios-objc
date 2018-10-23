//
//  CMPContentData.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 09/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPContentData.h"

@implementation CMPContentData

- (instancetype)initWithData:(NSData *)data type:(NSString *)type name:(NSString *)name {
    self = [super init];
    
    if (self) {
        self.data = data;
        self.type = type;
        self.name = name;
    }
    
    return self;
}

- (instancetype)initWithUrl:(NSURL *)url type:(NSString *)type name:(NSString *)name {
    self = [super init];
    
    if (self) {
        self.data = [NSFileManager.defaultManager contentsAtPath:url.absoluteString];
        self.type = type;
        self.name = name;
    }
    
    return self;
}

- (instancetype)initWithBase64Data:(NSString *)data type:(NSString *)type name:(NSString *)name {
    self = [super init];
    
    if (self) {
        self.data = [data dataUsingEncoding:NSUTF8StringEncoding];
        self.type = type;
        self.name = name;
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.name forKey:@"name"];
    [dict setValue:self.type forKey:@"type"];
    [dict setValue:[self.data base64EncodedStringWithOptions:0] forKey:@"data"];
    
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
