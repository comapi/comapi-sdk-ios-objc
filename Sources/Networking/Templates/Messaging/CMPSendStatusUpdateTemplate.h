//
//  CMPSendStatusUpdateTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 09/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"
#import "CMPMessageStatusUpdate.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SendStatusUpdateTemplate)
@interface CMPSendStatusUpdateTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, strong) NSString *conversationID;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSArray<CMPMessageStatusUpdate *> *statusUpdates;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID conversationID:(NSString *)conversationID token:(NSString *)token statusUpdates:(NSArray<CMPMessageStatusUpdate *> *)statusUpdates;

@end

NS_ASSUME_NONNULL_END
