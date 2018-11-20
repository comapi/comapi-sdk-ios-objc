//
//  CMPSendableMessage.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 08/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONEncoding.h"
#import "CMPMessagePart.h"
#import "CMPMessageAlert.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SendableMessage)
@interface CMPSendableMessage : NSObject <CMPJSONEncoding>

@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *metadata;
@property (nonatomic, strong, nullable) NSArray<CMPMessagePart *> *parts;
@property (nonatomic, strong, nullable) CMPMessageAlert *alert;

-(instancetype)initWithMetadata:(nullable NSDictionary<NSString *, id> *)metadata parts:(nullable NSArray<CMPMessagePart *> *)parts alert:(nullable CMPMessageAlert *)alert;

@end

NS_ASSUME_NONNULL_END
