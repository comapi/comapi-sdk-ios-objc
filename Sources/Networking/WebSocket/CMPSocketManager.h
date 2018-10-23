//
//  CMPSocketManager.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 02/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSessionAuthProvider.h"
#import "CMPAPIConfiguration.h"
#import "CMPComapiClient.h"

#import <SocketRocket/SocketRocket.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SocketManager)
@interface CMPSocketManager : NSObject <SRWebSocketDelegate>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID apiConfiguration:(CMPAPIConfiguration *)apiConfiguration sessionAuthProvider:(id<CMPSessionAuthProvider>)sessionAuthProvider;

- (void)bindClient:(CMPComapiClient *)client;

- (void)addEventDelegate:(id<CMPEventDelegate>)delegate;
- (void)removeEventDelegate:(id<CMPEventDelegate>)delegate;

- (void)startSocket;
- (void)closeSocket;

@end

NS_ASSUME_NONNULL_END
