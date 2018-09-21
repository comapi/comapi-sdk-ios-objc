//
//  CMPJSONDecoding.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 30/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMPJSONEncoding <NSObject>

- (nullable NSData *)encode:(NSError **)error;

@end
