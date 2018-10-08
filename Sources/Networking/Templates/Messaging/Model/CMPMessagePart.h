//
//  CMPMessagePart.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONEncoding.h"
#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPMessagePart : NSObject <CMPJSONEncoding, CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSString *type;
@property (nonatomic, strong, nullable) NSString *data;
@property (nonatomic, strong, nullable) NSNumber *size;
@property (nonatomic, strong, nullable) NSURL *url;

- (instancetype)initWithName:(NSString *)name type:(NSString *)type url:(NSURL *)url data:(NSString *)data size:(NSNumber *)size;

@end

NS_ASSUME_NONNULL_END

/*
 public struct MessagePart: Codable, Hashable {
 public var name: String?
 public var type: String?
 public var url: URL?
 public var data: String?
 public var size: Int?
 
 public init(name: String?, type: String?, url: URL?, data: String?, size: Int?) {
 self.name = name
 self.type = type
 self.url = url
 self.data = data
 self.size = size
 }
 
 private enum CodingKeys: String, CodingKey {
 case name = "name"
 case type = "type"
 case url = "url"
 case data = "data"
 case size = "size"
 }
 
 public var hashValue: Int {
 return xor(self.name?.hashValue,
 self.type?.hashValue,
 self.url?.hashValue,
 self.data?.hashValue,
 self.size?.hashValue)
 }
 
 public static func == (lhs: MessagePart, rhs: MessagePart) -> Bool {
 return (lhs.name == rhs.name
 && lhs.type == rhs.type
 && lhs.url == rhs.url
 && lhs.data == rhs.data
 && lhs.size == rhs.size)
 }
 }
 */
