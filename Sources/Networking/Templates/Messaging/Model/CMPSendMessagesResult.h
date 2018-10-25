//
//  CMPSendMessagesResult.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 09/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONDecoding.h"
#import "CMPJSONRepresentable.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPSendMessagesResult : NSObject <CMPJSONDecoding, CMPJSONRepresentable>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSNumber *eventID;

- (instancetype)initWithID:(NSString *)ID eventID:(NSNumber *)eventID;

@end

NS_ASSUME_NONNULL_END
