//
//  CMPProfile.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 11/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONDecoding.h"
#import "CMPJSONRepresentable.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Profile)
@interface CMPProfile : NSObject <CMPJSONDecoding, CMPJSONRepresentable>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSString *email;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
