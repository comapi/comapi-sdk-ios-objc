//
//  CMPMessageParticipant.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONDecoding.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPMessageParticipant : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSString *name;

- (instancetype)initWithID:(NSString *)ID name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
