//
// The MIT License (MIT)
// Copyright (c) 2017 Comapi (trading name of Dynmark International Limited)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "CMPSocketManager.h"
#import "CMPSocketTemplate.h"
#import "CMPEventParser.h"
#import "CMPBroadcastDelegate.h"
#import "CMPLogger.h"

NSUInteger const CMPSocketReopenDelay = 5;
NSUInteger const CMPPingTimerInterval = 240;

@interface CMPSocketManager () {
    NSTimer *pingTimer;
}

@property (nonatomic, strong, nullable) SRWebSocket *socket;
@property (nonatomic, strong, readonly) NSString *apiSpaceID;
@property (nonatomic, strong, readonly) CMPAPIConfiguration *apiConfiguration;

@property (nonatomic, weak, readonly) id<CMPSessionAuthProvider> sessionAuthProvider;
@property (nonatomic, weak, nullable) id<CMPSocketDelegate> socketDelegate;

@property (nonatomic, weak, nullable) CMPComapiClient *client;

@property (nonatomic, strong) CMPBroadcastDelegate<id<CMPEventDelegate>> *eventListener;

- (void)handleSocketMessage:(id)message;

@end

@implementation CMPSocketManager

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID apiConfiguration:(CMPAPIConfiguration *)apiConfiguration sessionAuthProvider:(id<CMPSessionAuthProvider>)sessionAuthProvider socketDelegate:(nonnull id)socketDelegate{
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
        logWithLevel(CMPLogLevelVerbose, @"Socket: received event:", event.name != nil ? event.name : @"unknown event name", event.json != nil ? event.json : @"unknown event data", nil);
    } else {
        logWithLevel(CMPLogLevelError, [NSString stringWithFormat:@"Socket: unexpected message type - %@", [message class]], message, nil);
    }
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    [self.socketDelegate didConnectSocket];
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
    [self.socketDelegate didDisconnectSocketWithError:error];
    logWithLevel(CMPLogLevelError, @"Socket: error", error.localizedDescription, nil);
    [pingTimer invalidate];
    self.socket = nil;
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, CMPSocketReopenDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf startSocket];
    });
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    [self.socketDelegate didDisconnectSocketWithError:nil];
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
