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
        let valid = newConversation.id != nil && newConversation.name != nil
        return valid
    }
    
    fileprivate func createRoles() -> Roles {
        let ownerAttributes = RoleAttributes(canSend: true, canAddParticipants: true, canRemoveParticipants: true)
        let participantAttributes = RoleAttributes(canSend: true, canAddParticipants: false, canRemoveParticipants: false)
        let roles = Roles(ownerAttributes: ownerAttributes, participantAttributes: participantAttributes)
        
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
        guard let myProfileId = client.profileID, let id = newConversation?.id, let name = newConversation?.name, validate() else { return }
        
        let me = ConversationParticipant(id: myProfileId, role: .owner)
        
        getConversation(for: id, success: { (converstion) in
            success(true, converstion)
        }) { [weak self] _ in
            guard let `self` = self else { return }
            let roles = self.createRoles()
            self.newConversation.participants = [me]
            self.newConversation.isPublic = NSNumber(booleanLiteral: isPublic)
            self.newConversation.roles = roles
            self.newConversation.id = id
            self.newConversation.name = name

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
