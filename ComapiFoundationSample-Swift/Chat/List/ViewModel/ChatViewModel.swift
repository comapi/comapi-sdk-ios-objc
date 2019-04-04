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

import CMPComapiFoundation

class ChatViewModel: NSObject {
    
    let client: ComapiClient
    let conversation: Conversation
    var messages: [Message]
    let downloader: ImageDownloader
    
    var inputMessage: SendableMessage!
    
    var didReadMessage: ((ConversationMessageEventRead) -> ())?
    var didReceiveMessage: (() -> ())?
    var didDeliverMessage: ((ConversationMessageEventDelivered) -> ())?
    var didStartTyping: (() -> ())?
    var didStopTyping: (() -> ())?
    var didTakeNewPhoto: ((UIImage) -> ())?
    
    init(client: ComapiClient, conversation: Conversation) {
        self.downloader = ImageDownloader()
        self.conversation = conversation
        self.client = client
        self.messages = []
        
        super.init()
        
        bind()
    }
    
    func bind() {
        client.add(self)
    }
    
    func getMessages(success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
        NotificationCenter.post(notification: Notification.Name.init(BaseViewController.LoadingBeginNotification))
        client.services.messaging.getMessages(conversationID: conversation.id) { (result) in
            NotificationCenter.post(notification: Notification.Name.init(BaseViewController.LoadingStopNotification))
            if let err = result.error {
                failure(err)
            } else {
                self.messages = result.object?.messages ?? []
                success()
            }
        }
    }
    
    func sendText(message: String, success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
        let metadata: [String : Any] = ["myMessageID" : "123"]
        let part = MessagePart(name: "",
                               type: "text/plain",
                               url: nil,
                               data: message,
                               size: NSNumber(integerLiteral: message.utf8.count))
        
        let message = SendableMessage(metadata: metadata, parts: [part], alert: nil)
        
        client.services.messaging.send(message: message, conversationID: conversation.id) { (result) in
            if let err = result.error {
                failure(err)
            } else {
                success()
            }
        }
    }
    
    func upload(content: ContentData, success: @escaping (ContentUploadResult) -> (), failure: @escaping (Error?) -> ()) {
        client.services.messaging.upload(content: content, folder: "folder") { (result) in
            if let err = result.error {
                failure(err)
            } else if let obj = result.object {
                success(obj)
            }
        }
    }
    
    func sendImage(content: ContentUploadResult, success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
        let metadata: [String : Any] = ["myMessageID" : "123"]
        let part = MessagePart(name: "image",
                               type: content.type,
                               url: content.url,
                               data: nil,
                               size: nil)
        let message = SendableMessage(metadata: metadata, parts: [part], alert: nil)
        client.services.messaging.send(message: message, conversationID: conversation.id) { (result) in
            if let err = result.error {
                failure(err)
            } else if let _ = result.object {
                success()
            }
        }
    }
    
    func showPhotoSourceActionSheetController(presenter: @escaping ((UIViewController) -> ()), alertPresenter: @escaping ((UIViewController) -> ()), pickerPresenter: @escaping ((UIViewController) -> ())) {
        let alert = UIAlertController(title: "Select Source", message: nil, preferredStyle: .actionSheet)
        
        if PhotoVideoManager.shared.isSourceAvailable(source: .photoLibrary) {
            let libraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] alert in
                guard let `self` = self else { return }
                PhotoVideoManager.shared.requestPhotoLibraryAccess() { success in
                    if success {
                        let vc = PhotoVideoManager.shared.imagePickerController(type: .photoLibrary, delegate: self)
                        pickerPresenter(vc)
                    } else {
                        PhotoVideoManager.shared.permissionAlert(withTitle: "Unable to access the Photo Library", message: "To enable access, go to Settings > Privacy > Photo Library and turn on Photo Library access for this app.", alertPresenter: { vc in
                            alertPresenter(vc)
                        })
                    }
                }
            })
            alert.addAction(libraryAction)
        }
        
        if PhotoVideoManager.shared.isSourceAvailable(source: .camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { [weak self] alert in
                guard let `self` = self else { return }
                PhotoVideoManager.shared.requestCameraAccess() { success in
                    if success {
                        let vc = PhotoVideoManager.shared.imagePickerController(type: .camera, delegate: self)
                        pickerPresenter(vc)
                    } else {
                        PhotoVideoManager.shared.permissionAlert(withTitle: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.", alertPresenter: { vc in
                            alertPresenter(vc)
                        })
                    }
                }
            })
            alert.addAction(cameraAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        
        presenter(alert)
    }

    func showPhotoCropController(image: UIImage, presenter: ((UIViewController) -> ())) {
        let vm = PhotoCropViewModel(image: image)
        let vc = PhotoCropViewController(viewModel: vm)
        presenter(vc)
    }
    
    func queryEvents(success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
        client.services.messaging.queryEvents(conversationID: conversation.id) { (result) in
            if let err = result.error {
                failure(err)
            } else if let _ = result.object?.compactMap({ $0 as? Event }) {
                success()
            }
        }
    }
    
    func consume(event: Event) {
        switch event.type {
        case .conversationMessageSent:
            guard let sent = event as? ConversationMessageEventSent, let id = sent.payload?.messageID, let metadata = sent.payload?.metadata, let context = sent.payload?.context, let parts = sent.payload?.parts, !messages.contains(where: { $0.id == id }) else { return }
            let msg = Message(id: id, sentEventID: sent.conversationEventID, metadata: metadata, context: context, parts: parts, statusUpdates: nil)
            messages.append(msg)
            didReceiveMessage?()
        case .conversationParticipantTypingOff:
            didStopTyping?()
        case .conversationParticipantTyping:
            didStartTyping?()
        case .conversationMessageRead:
            if let read = event as? ConversationMessageEventRead {
                didReadMessage?(read)
            }
        default:
            break
        }
    }
}

extension ChatViewModel: EventDelegate {
    func client(_ client: ComapiClient, didReceive event: Event) {
        consume(event: event)
    }
}

extension ChatViewModel: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage, let resized = image.resize() {
                self.didTakeNewPhoto?(resized)
            } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let resized = image.resize() {
                self.didTakeNewPhoto?(resized)
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


