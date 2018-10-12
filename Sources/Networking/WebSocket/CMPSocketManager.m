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
        __block CMPEvent *event = [CMPEventParser parseEventForData:data];
        [self.eventListener invokeDelegatesWithBlock:^(id<CMPEventDelegate> _Nonnull delegate) {
            [delegate client:self.client didReceiveEvent:event];
        }];
        logWithLevel(CMPLogLevelVerbose, @"Socket: received event:", event.name, nil);
    } else {
        logWithLevel(CMPLogLevelError, [NSString stringWithFormat:@"Socket: unexpected message type - %@", [message class], nil], message);
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
    logWithLevel(CMPLogLevelVerbose, @"Socket: closed with code:", code, @"reason:", reason, @"clean close:", wasClean, nil);
    [pingTimer invalidate];
    self.socket = nil;
}

@end

/*
 import Foundation
 import SwiftWebSocket
 import MulticastDelegateSwift
 
 internal final class SocketManager{
 private static let socketReopenDelay = 5
 
 private var socket: WebSocket?
 private let apiSpaceId: String
 private let apiConfiguration: APIConfiguration
 private let sessionAuthProvider: SessionAuthProvider
 private let eventListeners = MulticastDelegate<EventListener>()
 private weak var client: ComapiClient?
 
 init(apiSpaceId: String, apiConfiguration: APIConfiguration, sessionAuthProvider: SessionAuthProvider){
 self.apiSpaceId = apiSpaceId
 self.apiConfiguration = apiConfiguration
 self.sessionAuthProvider = sessionAuthProvider
 }
 
 internal func setClient(client: ComapiClient){
 self.client = client
 }
 
 internal func startSocket() {
 guard self.socket == nil else { return }
 
 do {
 let pingInterval: TimeInterval = 240
 var pingTimer: Timer?
 
 let template = try SocketTemplate(socketScheme: apiConfiguration.scheme,
 host: apiConfiguration.host,
 port: apiConfiguration.port,
 apiSpaceId: apiSpaceId,
 token: sessionAuthProvider.sessionAuth.unwrapped().token)
 let urlRequest = try template.urlRequest()
 
 let socket = WebSocket(request: urlRequest)
 
 socket.event.open = {
 log.info("Socket: opened")
 }
 
 socket.event.pong = { msg in
 log.verbose("Socket: pong", msg)
 }
 
 socket.event.close = { [unowned self] code, reason, clean in
 log.info("Socket: closed", code, reason, "clean:", clean)
 pingTimer?.invalidate()
 self.socket = nil
 }
 
 socket.event.error = { error in
 
 log.error("Socket: error \(error)")
 self.socket = nil
 DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(SocketManager.socketReopenDelay) ) {
 self.startSocket()
 }
 }
 
 socket.event.message = { [weak self] message in
 print(message as! String)
 self?.handleSocketMessage(message)
 }
 
 pingTimer = Timer.scheduledTimer(timeInterval: pingInterval,
 target: BlockOperation {
 log.verbose("Socket: ping")
 socket.ping()
 },
 selector: #selector(Operation.main),
 userInfo: nil,
 repeats: true)
 
 self.socket = socket
 }
 catch {
 log.error("Socket: error", error)
 }
 }
 
 internal func closeSocket(){
 self.socket?.close()
 }
 
 internal func addEventDelegate(_ delegate: EventListener) {
 log.verbose("event delegate added", delegate)
 self.eventListeners.addDelegate(delegate)
 }
 
 internal func removeEventDelegate(_ delegate: EventListener) {
 self.eventListeners.removeDelegate(delegate)
 log.verbose("event delegate removed", delegate)
 }
 
 internal func handleSocketMessage(_ message: Any) {
 if let text = message as? String {
 do {
 let data = try text.data(using: .utf8).unwrapped()
 let event = try Event.from(jsonData: data)
 log.verbose("Socket: received event: ", event)
 self.eventListeners.invokeDelegates { $0.client(client: self.client!, didReceiveEvent: event) }
 }
 catch {
 log.error("Socket: unrecognized message", error)
 }
 }
 else {
 log.error("Socket: unexpected message type", type(of: message), message)
 }
 }
 }
 */
