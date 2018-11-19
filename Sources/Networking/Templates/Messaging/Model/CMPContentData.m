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
        self.data = [NSData dataWithContentsOfURL:url];
        self.type = type;
        self.name = name;
    }
    
    return self;
}

- (instancetype)initWithBase64Data:(NSString *)data type:(NSString *)type name:(NSString *)name {
    self = [super init];
    
    if (self) {
        self.data = [[NSData alloc] initWithBase64EncodedString:data options:0];
        self.type = type;
        self.name = name;
    }
    
    return self;
}

#pragma mark - CMPJSONEncoding

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
