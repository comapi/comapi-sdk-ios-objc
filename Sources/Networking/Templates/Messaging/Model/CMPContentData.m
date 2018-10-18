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

//private enum CodingKeys: String, CodingKey {
//case name = "name"
//case data = "data"
//case type = "type"
//    }


//public var name: String?
//public var data: Data?
//public var type: String?
//
//public func encode(to encoder: Encoder) throws {
//    var container = encoder.container(keyedBy: CodingKeys.self)
//    if let data = self.data?.base64EncodedString() {
//        try container.encode(data, forKey: .data)
//    }
//    if let name = self.name {
//        try container.encode(name, forKey: .name)
//    }
//    if let type = self.type {
//        try container.encode(type, forKey: .type)
//    }
//    }
//
//    public init(data: Data, type: String? = nil, name: String? = nil) {
//        self.data = data
//        self.name = name
//        self.type = type
//    }
//
//    public init(url: URL, type: String? = nil, name: String? = nil) {
//        self.data = FileManager.default.contents(atPath: url.absoluteString)
//        self.name = name
//        self.type = type
//    }
//
//    public init(data: String, type: String? = nil, name: String? = nil) {
//        self.data = Data.init(base64Encoded: data)
//        self.name = name
//        self.type = type
//    }
//
//    public var hashValue: Int {
//        return xor(data?.hashValue,
//                   type?.hashValue,
//                   name?.hashValue)
//    }
//
//    public static func == (lhs: ContentData, rhs: ContentData) -> Bool {
//        return lhs.data == rhs.data &&
//        lhs.type == rhs.type &&
//        lhs.name == rhs.name
//    }

    
