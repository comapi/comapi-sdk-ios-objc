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
