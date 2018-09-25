//
//  CMPProfile.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 11/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPProfile : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSString *email;

- (instancetype)initWithJSON:(NSDictionary<NSString *, id> *)JSON;

@end

NS_ASSUME_NONNULL_END
