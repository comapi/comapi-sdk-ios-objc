//
//  CMPJSONEncoding.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 30/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_SWIFT_NAME(JSONDecoding)
@protocol CMPJSONDecoding <NSObject>

- (nullable instancetype)decodeWithData:(NSData *)data;

@end
