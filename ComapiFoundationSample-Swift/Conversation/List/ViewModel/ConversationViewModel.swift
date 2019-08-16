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


import UserNotifications


class ConversationViewModel: NSObject {
    
    let client: ComapiClient
    
    var conversations: [Conversation]
    
    var shouldReload: (() -> ())?
    
    init(client: ComapiClient) {
        self.client = client
        self.conversations = []
        
        super.init()
        
        self.client.add(self)
    }

    func getConversation(for id: String, success: @escaping (Conversation) -> (), failure: @escaping (Error?) -> ()) {
        NotificationCenter.post(notification: Notification.Name.init(BaseViewController.LoadingBeginNotification))
        client.services.messaging.getConversation(conversationID: id, completion: { (result) in
            NotificationCenter.post(notification: Notification.Name.init(BaseViewController.LoadingStopNotification))
            if let err = result.error {
                failure(err)
            } else if let obj = result.object {
                success(obj)
            }
        })
    }
    
    func deleteConversation(for id: String, success: @escaping (Bool) -> (), failure: @escaping (Error?) -> ()) {
        NotificationCenter.post(notification: Notification.Name.init(BaseViewController.LoadingBeginNotification))
        client.services.messaging.deleteConversation(conversationID: id, eTag: nil) { (result) in
            NotificationCenter.post(notification: Notification.Name.init(BaseViewController.LoadingStopNotification))
            if let err = result.error {
                failure(err)
            } else if let isOk = result.object?.boolValue {
                success(isOk)
            }
        }
    }
    
    func getAllConverstations(success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
        NotificationCenter.post(notification: Notification.Name.init(BaseViewController.LoadingBeginNotification))
        client.services.messaging.getConversations(profileID: client.profileID!, isPublic: false, completion: { (result) in
            NotificationCenter.post(notification: Notification.Name.init(BaseViewController.LoadingStopNotification))
            if let err = result.error {
                failure(err)
            } else {
                self.conversations = result.object?.compactMap({ $0 as? Conversation }) ?? []
                success()
            }
        })
    }
    
    func registerForRemoteNotification(completion: @escaping ((Bool, Error?) -> ())) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (success, error) in
            completion(success, error)
        }
    }
}

extension ConversationViewModel: EventDelegate {
    func client(_ client: ComapiClient, didReceive event: Event) {
        switch event.type {
        case .conversationUpdate:
            if let e = event as? ConversationEventUpdate, let conversation = conversations.first(where: { $0.id == e.conversationID }) {
                conversation.name = e.payload?.name ?? conversation.name
                conversation.conversationDescription = e.payload?.eventDescription ?? conversation.conversationDescription
                conversation.isPublic = e.payload?.isPublic ?? conversation.isPublic
                conversation.roles = e.payload?.roles ?? conversation.roles
                
                shouldReload?()
            }
        case .conversationDelete:
            if let e = event as? ConversationEventDelete {
                for (i, c) in conversations.enumerated() {
                    if c.id == e.conversationID {
                        conversations.remove(at: i)
                    }
                }
                shouldReload?()
            }
        case .conversationParticipantAdded:
            if let e = event as? ConversationEventParticipantAdded {
                self.client.services.messaging.getConversation(conversationID: e.conversationID ?? "") { [weak self] (result) in
                    if let err = result.error {
                        print(err.localizedDescription)
                    } else if let conv = result.object {
                        self?.conversations.append(conv)
                        self?.shouldReload?()
                    }
                }
            }
        case .none:
            return
        default:
            break
        }
    }
}
