//
//  ConversationViewModel.swift
//  ComapiChatSDKTestApp
//
//  Created by Dominik Kowalski on 03/07/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import CMPComapiFoundation

class ConversationViewModel {
    
    let client: ComapiClient
    
    var conversations: [Conversation]
    
    init(client: ComapiClient) {
        self.client = client
        self.conversations = []
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
}
