//
//  CMPChatViewModel.h
//  SampleApp
//
//  Created by Dominik Kowalski on 15/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPComapiClient.h"
#import "CMPPhotoCropViewController.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMPChatViewModel : NSObject <CMPEventDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) CMPComapiClient *client;
@property (nonatomic, strong) CMPConversation *conversation;
@property (nonatomic, strong) NSArray<CMPMessage *> *messages;

@property (nonatomic, copy) void(^didReceiveMessage)(void);
@property (nonatomic, copy) void(^didTakeNewPhoto)(UIImage *);

- (instancetype)initWithClient:(CMPComapiClient *)client conversation:(CMPConversation *)conversation;

- (void)getMessagesWithCompletion:(void(^)(NSArray<CMPMessage *> * _Nullable, NSError * _Nullable))completion;
- (void)sendTextMessage:(NSString *)message completion:(void(^)(NSError * _Nullable))completion;
- (void)uploadContent:(CMPContentData *)content completion:(void(^)(CMPContentUploadResult * _Nullable, NSError * _Nullable))completion;
- (void)sendImageWithUploadResult:(CMPContentUploadResult *)result completion:(void(^)(NSError * _Nullable))completion;
- (void)showPhotoSourceControllerWithPresenter:(void (^)(UIViewController *))presenter alertPresenter:(void (^)(UIViewController *))alertPresenter pickerPresenter:(void (^)(UIViewController *))pickerPresenter;
- (void)showPhotoCropControllerWithImage:(UIImage *)image presenter:(void(^)(UIViewController *))presenter;
@end

NS_ASSUME_NONNULL_END

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
//        let metadata: [String : Any] = ["myMessageID" : "123"]
//        let part = MessagePart(name: "",
//                               type: "text/plain",
//                               url: nil,
//                               data: message,
//                               size: message.utf8.count)
//
//        let message = SendableMessage(metadata: metadata, parts: [part])
//
//        client.services.messaging.send(message: message, toConversationWithId: conversation.id) { (result) in
//            switch result {
//            case .success(let messages):
//                success()
//            case .failure(let error):
//                failure(error)
//            }
//        }
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

//

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

//
//
