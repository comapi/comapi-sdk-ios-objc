//
//  CMPJSONEncoding.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 30/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMPJSONDecoding <NSObject>

- (nullable instancetype)decodeWithData:(NSData *)data error:(NSError **)error;

@end
