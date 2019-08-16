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

import UIKit


class AddParticipantViewModel {
    
    struct ValidationError: Error {
        var localizedDescription: String {
            return "Participant ID not set."
        }
    }
    
    let client: ComapiClient
    let conversationId: String
    
    var participant: ConversationParticipant!
    
    init(client: ComapiClient, conversationId: String) {
        self.client = client
        self.conversationId = conversationId
        self.participant = ConversationParticipant()
    }
    
    func update(id: String) {
        participant.id = id
    }
    
    func validate() -> Bool {
        return participant.id != nil
    }
    
    func getProfile(for id: String, success: @escaping (Bool) -> (), failure: @escaping (Error?) -> ()) {
        NotificationCenter.post(notification: Notification.Name.init(BaseViewController.LoadingBeginNotification))
        client.services.profile.getProfile(profileID: id) { (result) in
            NotificationCenter.post(notification: Notification.Name.init(BaseViewController.LoadingStopNotification))
            if let err = result.error {
                failure(err)
            } else {
                success(true)
            }
        }
    }
    
    func showAlert(title: String, error: Error, presenter: @escaping (UIViewController) -> ()) {
        let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        presenter(alertController)
    }
    
    func addParticipant(success: @escaping (Bool) -> (), failure: @escaping (Error?) -> ()) {
        if !validate() {
            failure(ValidationError())
            return
        }
        participant.role = .participant
        NotificationCenter.post(notification: Notification.Name.init(BaseViewController.LoadingBeginNotification))
        getProfile(for: participant.id!, success: { [weak self] (result) in
            guard let `self` = self else { return }
            self.client.services.messaging.addParticipants(conversationID: self.conversationId, participants: [self.participant]) { (result) in
                NotificationCenter.post(notification: Notification.Name.init(BaseViewController.LoadingStopNotification))
                if let err = result.error {
                    failure(err)
                } else {
                    success(result.object!.boolValue)
                }
            }
        }) { (error) in
            failure(error)
        }
    }
}
