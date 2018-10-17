//
//  CMPJSONDecoding.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 30/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "NSObject+CMPUtility.h"

NS_SWIFT_NAME(JSONEncoding)
@protocol CMPJSONEncoding <NSObject>
@optional
- (nullable NSData *)encode;
- (id)json;

@end
