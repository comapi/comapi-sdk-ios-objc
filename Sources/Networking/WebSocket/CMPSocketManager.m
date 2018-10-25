//
//  CMPSocketManager.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 02/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSocketManager.h"
#import "CMPSocketTemplate.h"
#import "CMPEventParser.h"
#import "CMPBroadcastDelegate.h"

NSUInteger const CMPSocketReopenDelay = 5;
NSUInteger const CMPPingTimerInterval = 240;

@interface CMPSocketManager () {
    NSTimer *pingTimer;
}

@property (nonatomic, strong, nullable) SRWebSocket *socket;
@property (nonatomic, strong, readonly) NSString *apiSpaceID;
@property (nonatomic, strong, readonly) CMPAPIConfiguration *apiConfiguration;
@property (nonatomic, strong, readonly) id<CMPSessionAuthProvider> sessionAuthProvider;
@property (nonatomic, strong) CMPBroadcastDelegate<id<CMPEventDelegate>> *eventListener;
@property (nonatomic, weak, nullable) CMPComapiClient *client;

- (void)handleSocketMessage:(id)message;

@end

@implementation CMPSocketManager

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID apiConfiguration:(CMPAPIConfiguration *)apiConfiguration sessionAuthProvider:(id<CMPSessionAuthProvider>)sessionAuthProvider {
    self = [super init];
    
    if (self) {
        _apiSpaceID = apiSpaceID;
        _apiConfiguration = apiConfiguration;
        _sessionAuthProvider = sessionAuthProvider;
        _eventListener = [[CMPBroadcastDelegate alloc] init];
    }
    
    return self;
}

- (void)bindClient:(CMPComapiClient *)client {
    self.client = client;
}

- (void)addEventDelegate:(id<CMPEventDelegate>)delegate {
    [self.eventListener addDelegate:delegate];
    logWithLevel(CMPLogLevelVerbose, @"Socket: event delegate added:", delegate, nil);
}

- (void)removeEventDelegate:(id<CMPEventDelegate>)delegate {
    [self.eventListener removeDelegate:delegate];
    logWithLevel(CMPLogLevelVerbose, @"Socket: event delegate removed:", delegate, nil);
}

- (void)startSocket {
    if (self.socket != nil) {
        return;
    }
    pingTimer = [NSTimer scheduledTimerWithTimeInterval:CMPPingTimerInterval target:self selector:@selector(sendPing) userInfo:nil repeats:YES];
    
    NSString *token = self.sessionAuthProvider.sessionAuth.token;
    if (!token) {
        logWithLevel(CMPLogLevelError, @"Socket: No authorization token, intercepting socket connection...", nil);
        return;
    }
    
    CMPSocketTemplate *template = [[CMPSocketTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID token:token];
    NSURLRequest *request = [template requestFromHTTPRequestTemplate:template];
    self.socket = [[SRWebSocket alloc] initWithURLRequest:request];
    self.socket.delegate = self;
    [self.socket open];
}

- (void)closeSocket {
    [pingTimer invalidate];
    [self.socket close];
}

- (void)sendPing {
    logWithLevel(CMPLogLevelVerbose, @"Socket: ping", nil);
    [self.socket sendPing:nil];
}

- (void)handleSocketMessage:(id)message {
    if ([message isKindOfClass:NSString.class]) {
        NSData *data = [(NSString *)message dataUsingEncoding:NSUTF8StringEncoding];
        CMPEvent *event = [CMPEventParser parseEventForData:data];
        [self.eventListener invokeDelegatesWithBlock:^(id<CMPEventDelegate> _Nonnull delegate) {
            [delegate client:self.client didReceiveEvent:event];
        }];
        logWithLevel(CMPLogLevelVerbose, @"Socket: received event:", event.name, event.json, nil);
    } else {
        logWithLevel(CMPLogLevelError, [NSString stringWithFormat:@"Socket: unexpected message type - %@", [message class]], message, nil);
    }
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    logWithLevel(CMPLogLevelVerbose, @"Socket: opened", nil);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    [self handleSocketMessage:message];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSString *message = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    logWithLevel(CMPLogLevelVerbose, @"Socket: pong", message, nil);
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    logWithLevel(CMPLogLevelError, @"Socket: error", error.localizedDescription, nil);
    [pingTimer invalidate];
    self.socket = nil;
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, CMPSocketReopenDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf startSocket];
    });
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    logWithLevel(CMPLogLevelVerbose, @"Socket: closed with code:", [NSNumber numberWithInteger:code], @"reason:", reason != nil ? reason : @"", @"clean close:", [NSNumber numberWithBool:wasClean], nil);
    [pingTimer invalidate];
    self.socket = nil;
    if (!wasClean) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, CMPSocketReopenDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [weakSelf startSocket];
        });
    }
}

@end
