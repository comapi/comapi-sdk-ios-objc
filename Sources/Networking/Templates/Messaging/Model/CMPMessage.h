//
//  CMPMessage.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 05/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMessageStatus.h"
#import "CMPMessagePart.h"
#import "CMPMessageContext.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Message)
@interface CMPMessage : NSObject <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *metadata;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, CMPMessageStatus *> *statusUpdates;
@property (nonatomic, strong, nullable) NSArray<CMPMessagePart *> *parts;
@property (nonatomic, strong, nullable) CMPMessageContext *context;

-(instancetype)initWithID:(nullable NSString *)ID metadata:(nullable NSDictionary<NSString *, id> *)metadata context:(nullable CMPMessageContext *)context parts:(nullable NSArray<CMPMessagePart *> *)parts statusUpdates:(nullable NSDictionary<NSString *, CMPMessageStatus *> *)statusUpdates;

@end

NS_ASSUME_NONNULL_END

//public var id: String?
//public var metadata: [String : Any]?
//public var context: MessageContext?
//public var parts: [MessagePart]?
//public var statusUpdates: [String: MessageStatusUpdate]?
//
//public init(id: String?,
//            metadata: [String : Any]?,
//            context: MessageContext?,
//            parts: [MessagePart]?,
//            statusUpdates: [String: MessageStatusUpdate]?) {
//
//    self.id = id
//    self.metadata = metadata
//    self.context = context
//    self.parts = parts
//    self.statusUpdates = statusUpdates
//    }
