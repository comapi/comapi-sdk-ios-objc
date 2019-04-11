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



class ChatViewModel: NSObject {
    
    let client: ComapiClient
    let conversation: Conversation
    var messages: [Message]
    var attachments: [UIImage]
    let downloader: ImageDownloader
    
    var inputMessage: SendableMessage!
    
    var shouldReloadAttachments: (() -> ())?
    var shouldReloadMessages: ((_ showNewMessageView: Bool) -> ())?
    var shouldReloadMessageAtIndex: ((_ index: Int) -> ())?
    var didTakeNewPhoto: ((UIImage) -> ())?
    
    init(client: ComapiClient, conversation: Conversation) {
        self.downloader = ImageDownloader()
        self.conversation = conversation
        self.client = client
        self.messages = []
        self.attachments = []
        
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
    
    func markRead(messageId: String, completion: ((Error?) -> ())?) {
        self.client.services.messaging.updateStatus(messageIDs: [messageId], status: .read, conversationID: conversation.id, timestamp: Date()) { result in
            if let err = result.error {
                print(err.localizedDescription)
            }
            completion?(result.error)
        }
    }
    
    func markDelivered(messageId: String, completion: ((Error?) -> ())?) {
        self.client.services.messaging.updateStatus(messageIDs: [messageId], status: .delivered, conversationID: conversation.id, timestamp: Date()) { result in
            if let err = result.error {
                print(err.localizedDescription)
            }
            completion?(result.error)
        }
    }
    
    func markAllRead() {
        var unread = [String]()
        messages.forEach { (msg) in
            if msg.statusUpdates?[client.profileID!] == nil || msg.statusUpdates?[client.profileID!]?.status != .read {
                unread.append(msg.id!)
            }
        }
        self.client.services.messaging.updateStatus(messageIDs: unread, status: .read, conversationID: conversation.id, timestamp: Date()) { result in
            if let err = result.error {
                print(err.localizedDescription)
            }
        }
    }
    
    func createImagePart(upload: ContentUploadResult) -> MessagePart {
        let part = MessagePart(name: "image",
                               type: upload.type,
                               url: upload.url,
                               data: nil,
                               size: nil)
        return part
    }
    
    func createTextPart(message: String) -> MessagePart {
        let part = MessagePart(name: "",
                               type: "text/plain",
                               url: nil,
                               data: message,
                               size: NSNumber(integerLiteral: message.utf8.count))
        
        return part
    }
    
    func send(message: String, completion: @escaping (Error?) -> ()) {
        convertAndUpload { [weak self] (uploadResult) in
            guard let `self` = self else { return }
            var parts = [MessagePart]()
            
            if message != "" {
                let textPart = self.createTextPart(message: message)
                parts.append(textPart)
            }

            for upload in uploadResult {
                let part = self.createImagePart(upload: upload)
                parts.append(part)
            }
            
            let platform = MessageAlertPlatforms(apns: ["badge" : 1,
                                                        "alert" : message != "" ? message : "New image.",
                                                        "payload" : ["conversationId" : self.conversation.id]],
                                                 fcm: ["notification" : ["body" : message != "" ? message : "New image.",
                                                                         "tag" : self.conversation.name,
                                                                         "title" : self.conversation.name]])
            let alert = MessageAlert(platforms: platform)
            
            let message = SendableMessage(metadata: nil, parts: parts, alert: alert)
            self.client.services.messaging.send(message: message, conversationID: self.conversation.id) { (result) in
                self.attachments = []
                DispatchQueue.main.async {
                    completion(result.error)
                }
            }
        }
    }
    
    func convertAndUpload(completion: @escaping ([ContentUploadResult]) -> ()) {
        let group = DispatchGroup()
        var results = [ContentUploadResult]()
        
        for (idx, image) in attachments.enumerated() {
            group.enter()
            guard let jpg = image.jpegData(compressionQuality: 0.6) else {
                group.leave()
                return
            }

            let data = ContentData(data: jpg, type: "image/jpg", name: "image-\(idx)")
            client.services.messaging.upload(content: data, folder: "images") { (result) in
                if let res = result.object {
                    results.append(res)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(results)
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
            guard let e = event as? ConversationMessageEventSent,
                  let messageId = e.payload?.messageID,
                  let profileId = e.payload?.context?.from?.id else { return }
            let isMyOwn = profileId == client.profileID
            
            self.getMessages(success: { [weak self] in
                self?.shouldReloadMessages?(!isMyOwn)
                self?.markDelivered(messageId: messageId, completion: nil)
                }, failure: { [weak self] (err) in
                self?.shouldReloadMessages?(!isMyOwn)
            })
        case .conversationMessageDelivered:
            guard let e = event as? ConversationMessageEventDelivered,
                let messageId = e.payload?.messageID,
                let profileId = e.payload?.profileID,
                let idx = messages.firstIndex(where: { $0.id! == messageId }) else { return }
            
            if let currentStatus = messages[idx].statusUpdates?[profileId]?.status, currentStatus == .read { return }
            
            if messages[idx].statusUpdates == nil {
                messages[idx].statusUpdates = [:]
            }
            let status = MessageStatus(status: .delivered, timestamp: Date())
            let newDict = messages[idx].statusUpdates?.merging([profileId : status], uniquingKeysWith: { (current, new) -> MessageStatus in
                return new
            }) ?? [:]
            messages[idx].statusUpdates = newDict
            shouldReloadMessageAtIndex?(idx)
            markRead(messageId: messageId, completion: nil)
        case .conversationMessageRead:
            guard let e = event as? ConversationMessageEventRead,
                let messageId = e.payload?.messageID,
                let profileId = e.payload?.profileID,
                let idx = messages.firstIndex(where: { $0.id! == messageId }) else { return }
            
            if messages[idx].statusUpdates == nil {
                messages[idx].statusUpdates = [:]
            }
            let status = MessageStatus(status: .read, timestamp: Date())
            let newDict = messages[idx].statusUpdates?.merging([profileId : status], uniquingKeysWith: { (current, new) -> MessageStatus in
                return new
            }) ?? [:]
            messages[idx].statusUpdates = newDict
            shouldReloadMessageAtIndex?(idx)
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


