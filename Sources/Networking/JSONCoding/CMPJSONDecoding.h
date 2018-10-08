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
@required
- (nullable instancetype)decodeWithData:(NSData *)data;

@optional
- (instancetype)initWithJSON:(id)JSON;

@end
