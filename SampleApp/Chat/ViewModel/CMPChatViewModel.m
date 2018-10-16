//
//  CMPChatViewModel.m
//  SampleApp
//
//  Created by Dominik Kowalski on 15/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPChatViewModel.h"
#import "CMPEventParser.h"
#import "CMPConversationMessageEvents.h"

@implementation CMPChatViewModel

- (instancetype)initWithClient:(CMPComapiClient *)client conversation:(CMPConversation *)conversation {
    self = [super init];
    
    if (self) {
        self.client = client;
        self.conversation = conversation;
        self.messages = @[];
        
        [self.client addEventDelegate:self];
    }
    
    return self;
}

- (void)getMessagesWithCompletion:(void (^)(NSArray<CMPMessage *> * _Nullable, NSError * _Nullable))completion {
    [self.client.services.messaging getMessagesWithConversationID:self.conversation.id limit:100 from:0 completion:^(CMPGetMessagesResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
        } else {
            self.messages = result.messages;
            completion(result.messages, nil);
        }
    }];
}

- (void)sendTextMessage:(NSString *)message completion:(void (^)(NSError * _Nullable))completion {
    NSDictionary<NSString *, id> *metadata = @{@"myMessageID" : @"123"};
    CMPMessagePart *part = [[CMPMessagePart alloc] initWithName:@"" type:@"text/plain" url:nil data:message size:[NSNumber numberWithUnsignedLong:sizeof(message.UTF8String)]];
    CMPSendableMessage *sendableMessage = [[CMPSendableMessage alloc] initWithMetadata:metadata parts:@[part] alert:nil];
    [self.client.services.messaging sendMessage:sendableMessage toConversationWithID:self.conversation.id completion:^(CMPSendMessagesResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            completion(error);
        } else {
            completion(nil);
        }
    }];
}

#pragma mark - CMPEventDelegate

- (void)client:(CMPComapiClient *)client didReceiveEvent:(CMPEvent *)event {
    if ([event.name isEqualToString:@"conversationMessage.sent"]) {
        CMPConversationMessageEventSent *sentEvent = (CMPConversationMessageEventSent *)event;
        NSString *messageID = sentEvent.payload.messageID;
        NSDictionary *metadata = sentEvent.payload.metadata;
        CMPMessageContext *context = sentEvent.payload.context;
        NSArray<CMPMessagePart *> *parts = sentEvent.payload.parts;
        
        __block BOOL contains = NO;
        [self.messages enumerateObjectsUsingBlock:^(CMPMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.id isEqualToString:messageID]) {
                contains = YES;
                *stop = YES;
            }
        }];
        if (contains) {
            return;
        }
        CMPMessage *message = [[CMPMessage alloc] initWithID:messageID metadata:metadata context:context parts:parts statusUpdates:nil];
        self.messages = [self.messages arrayByAddingObject:message];
        if (self.didReceiveMessage) {
            self.didReceiveMessage();
        }
    }
}

@end

//
//  ChatViewModel.swift
//  ComapiChatSDKTestApp
//
//  Created by Dominik Kowalski on 02/07/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

//import ComapiFoundation
//
//class ChatViewModel: NSObject {
//
//    let client: ComapiClient
//    let conversation: Conversation
//    var messages: [Message]
//    let downloader: ImageDownloader
//
//    var inputMessage: SendableMessage!
//
//    var didReadMessage: ((Event.ConversationMessage.Read) -> ())?
//    var didReceiveMessage: (() -> ())?
//    var didDeliverMessage: ((Event.ConversationMessage.Delivered) -> ())?
//    var didStartTyping: (() -> ())?
//    var didStopTyping: (() -> ())?
//    var didTakeNewPhoto: ((UIImage) -> ())?
//
//    init(client: ComapiClient, conversation: Conversation) {
//        self.downloader = ImageDownloader()
//        self.conversation = conversation
//        self.client = client
//        self.messages = []
//
//        super.init()
//
//        bind()
//    }
//
//    func bind() {
//        client.addEventDelegate(self)
//    }
//
//    func getMessages(success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
//        NotificationCenter.post(notification: Notification.Name.init(BaseViewController.LoadingBeginNotification))
//        client.services.messaging.getMessages(forConversationID: conversation.id) { (result) in
//            NotificationCenter.post(notification: Notification.Name.init(BaseViewController.LoadingStopNotification))
//            switch result {
//            case .success(let messages):
//                self.messages = messages.messages ?? []
//                success()
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//
//    func sendText(message: String, success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
//
//    }
//
//    func upload(content: ContentData, success: @escaping (ContentUploadResult) -> (), failure: @escaping (Error?) -> ()) {
//        client.services.messaging.upload(content: content, folder: "folder") { (result) in
//            switch result {
//            case .success(let value):
//                success(value)
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//
//    func sendImage(content: ContentUploadResult, success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
//        let metadata: [String : Any] = ["myMessageID" : "123"]
//        let part = MessagePart(name: "image",
//                               type: content.type,
//                               url: content.url,
//                               data: nil,
//                               size: nil)
//        let message = SendableMessage(metadata: metadata, parts: [part])
//        client.services.messaging.send(message: message, toConversationWithId: conversation.id) { (result) in
//            switch result {
//            case .success(let _):
//                success()
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//
//    func showPhotoSourceActionSheetController(presenter: @escaping ((UIViewController) -> ()), alertPresenter: @escaping ((UIViewController) -> ()), pickerPresenter: @escaping ((UIViewController) -> ())) {
//        let alert = UIAlertController(title: "Select Source", message: nil, preferredStyle: .actionSheet)
//
//        if PhotoVideoManager.shared.isSourceAvailable(source: .photoLibrary) {
//            let libraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] alert in
//                guard let `self` = self else { return }
//                PhotoVideoManager.shared.requestPhotoLibraryAccess() { success in
//                    if success {
//                        let vc = PhotoVideoManager.shared.imagePickerController(type: .photoLibrary, delegate: self)
//                        pickerPresenter(vc)
//                    } else {
//                        PhotoVideoManager.shared.permissionAlert(withTitle: "Unable to access the Photo Library", message: "To enable access, go to Settings > Privacy > Photo Library and turn on Photo Library access for this app.", alertPresenter: { vc in
//                            alertPresenter(vc)
//                        })
//                    }
//                }
//            })
//            alert.addAction(libraryAction)
//        }
//
//        if PhotoVideoManager.shared.isSourceAvailable(source: .camera) {
//            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { [weak self] alert in
//                guard let `self` = self else { return }
//                PhotoVideoManager.shared.requestCameraAccess() { success in
//                    if success {
//                        let vc = PhotoVideoManager.shared.imagePickerController(type: .camera, delegate: self)
//                        pickerPresenter(vc)
//                    } else {
//                        PhotoVideoManager.shared.permissionAlert(withTitle: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.", alertPresenter: { vc in
//                            alertPresenter(vc)
//                        })
//                    }
//                }
//            })
//            alert.addAction(cameraAction)
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//        alert.addAction(cancelAction)
//
//        presenter(alert)
//    }
//
//    func showPhotoCropController(image: UIImage, presenter: ((UIViewController) -> ())) {
//        let vm = PhotoCropViewModel(image: image)
//        let vc = PhotoCropViewController(viewModel: vm)
//        presenter(vc)
//    }
//
//    func queryEvents(success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
//        client.services.messaging.queryEvents(forConversationID: conversation.id) { result in
//            switch result {
//            case .failure(let error):
//                failure(error)
//            case .success(let container):
//                for event in container {
//                    self.consume(event: event.event)
//                }
//            }
//        }
//    }
//
//    func consume(event: Event) {
//        switch event {
//        case .conversationMessage(.sent(let sent)):
//            guard let id = sent.payload?.messageID, let metadata = sent.payload?.metadata, let context = sent.payload?.context, let parts = sent.payload?.parts, !messages.contains(where: { $0.id == id }) else { return }
//            let msg = Message(id: id, metadata: metadata, context: context, parts: parts, statusUpdates: nil)
//            messages.append(msg)
//            didReceiveMessage?()
//        case .conversation(.participantTyping(let typing)):
//            didStartTyping?()
//        case .conversation(.participantTypingOff(let typingOff)):
//            didStopTyping?()
//        case .conversationMessage(.read(let messageRead)):
//            print("message \(messageRead.payload?.messageID) read")
//            messages.first(where: { $0.id == messageRead.payload?.messageID })
//            didReadMessage?(messageRead)
//        case .conversationMessage(.delivered(let messageDelivered)):
//            print("message \(messageDelivered.payload?.messageID) delivered")
//            didDeliverMessage?(messageDelivered)
//        default:
//            break
//        }
//    }
//}
//
//extension ChatViewModel: EventListener {
//    func client(client: ComapiClient, didReceiveEvent event: Event) {
//        consume(event: event)
//    }
//}
//
//extension ChatViewModel: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        picker.dismiss(animated: true) {
//            if let image = info[UIImagePickerControllerEditedImage] as? UIImage, let resized = image.resize() {
//                self.didTakeNewPhoto?(resized)
//            } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage, let resized = image.resize() {
//                self.didTakeNewPhoto?(resized)
//            }
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//}
//
//
