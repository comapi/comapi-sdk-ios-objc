//
//  CreateConversationViewModel.swift
//  ComapiChatSDKTestApp
//
//  Created by Dominik Kowalski on 03/07/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import CMPComapiFoundation

class CreateConversationViewModel {
    
    let client: ComapiClient
    var profiles: [Profile]
    var newConversation: NewConversation!
    
    init(client: ComapiClient) {
        self.client = client
        self.profiles = []
        
        self.newConversation = NewConversation()
    }
    
    fileprivate func validate() -> Bool {
        let valid = newConversation.conversationDescription != nil && newConversation.name != nil && newConversation.participants != nil
        return valid
    }
    
    fileprivate func createRoles() -> Roles {
        let ownerAttributes = RoleAttributes(canSend: true, canAddParticipants: true, canRemoveParticipants: true)
        let participantAttributes = RoleAttributes(canSend: true, canAddParticipants: false, canRemoveParticipants: false)
        let roles = Roles(ownerAttributes: ownerAttributes , participantAttributes: participantAttributes)
        
        return roles
    }
    
    func getProfiles(success: @escaping ([Profile]) -> (), failure: @escaping (Error?) -> ()) {
        NotificationCenter.post(notification: Notification.Name.init(BaseViewController.LoadingBeginNotification))
        client.services.profile.queryProfiles(queryElements: []) { (result) in
            NotificationCenter.post(notification: Notification.Name.init(BaseViewController.LoadingStopNotification))
            if let err = result.error {
                failure(err)
            } else if let obj = result.object?.compactMap({ $0 as? Profile }) {
                success(obj)
            }
        }
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
    
    func createConversation(isPublic: Bool = false, success: @escaping (_ alreadyExists: Bool, Conversation) -> (), failure: @escaping (Error?) -> ()) {
        guard let myProfileId = client.profileID, let name = newConversation?.name, !validate() else { return }
        
        let me = ConversationParticipant(id: myProfileId, role: "owner")
        let id = name + "_" + myProfileId
        
        getConversation(for: id, success: { (converstion) in
            success(true, converstion)
        }) { [weak self] _ in
            guard let `self` = self else { return }
            let roles = self.createRoles()
            self.newConversation.participants = [me]
            self.newConversation.isPublic = NSNumber(booleanLiteral: isPublic)
            self.newConversation.roles = roles
            self.newConversation.id = id

            NotificationCenter.post(notification: Notification.Name.init(BaseViewController.LoadingBeginNotification))
            self.client.services.messaging.addConversation(conversation: self.newConversation, completion: { (result) in
                NotificationCenter.post(notification: Notification.Name.init(BaseViewController.LoadingStopNotification))
                if let err = result.error {
                    failure(err)
                } else if let obj = result.object {
                    success(true, obj)
                }
            })
        }
    }
}
