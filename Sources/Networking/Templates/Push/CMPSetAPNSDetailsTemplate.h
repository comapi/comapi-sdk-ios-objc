//
//  SetAPNSDetailsTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 30/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"
#import "CMPAPNSDetailsBody.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPSetAPNSDetailsTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, strong) CMPAPNSDetailsBody *body;
@property (nonatomic, strong) NSString *sessionID;
@property (nonatomic, strong) NSString *token;

- (instancetype) initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID token:(NSString *)token sessionID:(NSString *)sessionID body:(CMPAPNSDetailsBody *)body;

@end

NS_ASSUME_NONNULL_END
