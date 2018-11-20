//
//  CMPJSONRepresentable.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 25/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(JSONRepresentable)
@protocol CMPJSONRepresentable <NSObject>

- (nullable id)json;

@end

NS_ASSUME_NONNULL_END
