//
//  CMPGetParticipantsTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(GetParticipantsTemplate)
@interface CMPGetParticipantsTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *conversationID;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID conversationID:(NSString *)conversationID token:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
