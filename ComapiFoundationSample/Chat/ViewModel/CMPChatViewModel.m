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

#import "CMPChatViewModel.h"
#import "CMPEventParser.h"
#import "CMPPhotoVideoManager.h"
#import "UIImage+CMPUtilities.h"

@implementation CMPChatViewModel

- (instancetype)initWithClient:(CMPComapiClient *)client conversation:(CMPConversation *)conversation {
    self = [super init];
    
    if (self) {
        self.client = client;
        self.conversation = conversation;
        self.messages = [NSMutableArray new];
        self.downloader = [[CMPImageDownloader alloc] init];
        self.imageAttachments = [NSMutableArray new];
        
        [self.client addEventDelegate:self];
    }
    
    return self;
}

- (void)addImageAttachment:(UIImage *)image {
    [self.imageAttachments addObject:image];
    if (_shouldReloadAttachments) {
        self.shouldReloadAttachments();
    }
}

- (void)getMessagesWithCompletion:(void (^)(NSArray<CMPMessage *> * _Nullable, NSError * _Nullable))completion {
    __weak typeof(self) weakSelf = self;
    [self.client.services.messaging getMessagesWithConversationID:self.conversation.id limit:100 from:0 completion:^(CMPResult<CMPGetMessagesResult *> *result) {
        if (result.error) {
            completion(nil, result.error);
        } else {
            weakSelf.messages = result.object.messages ? [NSMutableArray arrayWithArray:result.object.messages] : [NSMutableArray new];
            completion(weakSelf.messages, nil);
        }
    }];
}

- (void)getParticipantsWithCompletion:(void (^)(NSArray<CMPConversationParticipant *> * _Nullable, NSError * _Nullable))completion {
    __weak typeof(self) weakSelf = self;
    [self.client.services.messaging getParticipantsWithConversationID:self.conversation.id completion:^(CMPResult<NSArray<CMPConversationParticipant *> *> * _Nonnull result) {
        if (result.error) {
            NSLog(@"%@", result.error);
            completion(nil, result.error);
        } else {
            weakSelf.participants = [NSMutableArray arrayWithArray:result.object];
            completion(weakSelf.participants, nil);
        }
    }];
}

- (NSArray<CMPContentData *> *)convertImagesToContentData {
    NSMutableArray<CMPContentData *> *attachments = [NSMutableArray new];
    for (UIImage *i in _imageAttachments) {
        NSData *data = UIImageJPEGRepresentation(i, 0.6);
        CMPContentData *contentData = [[CMPContentData alloc] initWithData:data type:@"image/jpeg" name:@"image"];
        [attachments addObject:contentData];
    }
    
    return attachments;
}

- (CMPMessageAlert *)createAlert {
    NSDictionary<NSString *, id> *apns = @{@"alert" : @"yes",
                                          @"badge" : @(1),
                                           @"payload" : @{@"conversationId" : _conversation.id}};
    NSDictionary<NSString *, id> *fcm = @{@"\"collapse_key\"" : @"\"\"",
                                          @"badge" : @(1),
                                          @"data" : @{@"conversationId" : _conversation.id},
                                          @"notification" : @{@"body" : @"yes",
                                                              @"title" : @"New Message"}
                                          };
    CMPMessageAlertPlatforms *platforms = [[CMPMessageAlertPlatforms alloc] initWithApns:apns fcm:fcm];
    CMPMessageAlert *alert = [[CMPMessageAlert alloc] initWithPlatforms:platforms];
    return alert;
}

- (void)sendMessage:(nullable NSString *)message completion:(void (^)(NSError * _Nullable))completion {
    __weak typeof(self) weakSelf = self;
    
    NSMutableArray<CMPMessagePart *> *imageParts = [NSMutableArray new];
    NSArray<CMPContentData *> *allContent = [self convertImagesToContentData];
    dispatch_group_t group = dispatch_group_create();
    for (CMPContentData *cd in allContent) {
        dispatch_group_enter(group);
        [self.client.services.messaging uploadContent:cd folder:@"images" completion:^(CMPResult<CMPContentUploadResult *> * _Nonnull result) {
            if (result.error) {
                NSLog(@"%@", result.error.userInfo[NSUnderlyingErrorKey]);
            } else if (result.object) {
                CMPContentUploadResult *obj = result.object;
                CMPMessagePart *part = [[CMPMessagePart alloc] initWithName:nil type:obj.type url:obj.url data:nil size:obj.size];
                [imageParts addObject:part];
            }
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSArray<CMPMessagePart *> *partsToSend;
        if (message) {
            CMPMessagePart *textPart = [[CMPMessagePart alloc] initWithName:nil type:@"text/plain" url:nil data:message size:[NSNumber numberWithUnsignedLong:sizeof(message.UTF8String)]];
            partsToSend = [@[textPart] arrayByAddingObjectsFromArray:imageParts];
        } else {
            partsToSend = imageParts;
        }
        CMPSendableMessage *toSend = [[CMPSendableMessage alloc] initWithMetadata:@{} parts:partsToSend alert:[self createAlert]];
        [weakSelf.client.services.messaging sendMessage:toSend toConversationWithID:weakSelf.conversation.id completion:^(CMPResult<CMPSendMessagesResult *> * _Nonnull result) {
            weakSelf.imageAttachments = [NSMutableArray new];
            if (result.error) {
                NSLog(@"%@", @(result.code));
                completion(result.error);
            } else {
                completion(nil);
            }
        }];
    });
}

- (void)markRead:(NSString *)messageID completion:(void(^)(NSError * _Nullable))completion {
    [self.client.services.messaging updateStatusForMessagesWithIDs:@[messageID] status:CMPMessageDeliveryStatusRead conversationID:_conversation.id timestamp:[NSDate new] completion:^(CMPResult<NSNumber *> * _Nonnull result) {
        if (result.error) {
            NSLog(@"%@", result.error);
        }
        completion(result.error);
    }];
}

- (void)markDelivered:(NSString *)messageID completion:(void(^)(NSError * _Nullable))completion {
    [self.client.services.messaging updateStatusForMessagesWithIDs:@[messageID] status:CMPMessageDeliveryStatusDelivered conversationID:_conversation.id timestamp:[NSDate new] completion:^(CMPResult<NSNumber *> * _Nonnull result) {
        if (result.error) {
            NSLog(@"%@", result.error);
        }
        completion(result.error);
    }];
}
    
- (NSInteger)indexForMessageWithID:(NSString *)ID {
    for (int i = 0; i < _messages.count; i++) {
        if ([_messages[i].id isEqualToString:ID]) {
            return i;
        }
    }
    
    return -1;
}

- (void)markUnreadWithCompletion:(void(^)(BOOL, NSError * _Nullable))completion {
    NSString *profileID = self.client.profileID;
    NSMutableArray<NSString *> *unread = [NSMutableArray new];
    for (CMPMessage *m in _messages) {
        if (!m.statusUpdates[profileID]) {
            [unread addObject:m.id];
        }
    }
    if (unread.count == 0) {
        completion(NO, nil);
        return;
    }
    [self.client.services.messaging updateStatusForMessagesWithIDs:unread status:CMPMessageDeliveryStatusRead conversationID:self.conversation.id timestamp:[NSDate new] completion:^(CMPResult<NSNumber *> * _Nonnull result) {
        if (result.error) {
            NSLog(@"%@", result.error);
            completion(NO, result.error);
        } else {
            completion(YES, result.error);
        }
    }];
}

- (void)showPhotoSourceControllerWithPresenter:(void (^)(UIViewController * _Nonnull))presenter alertPresenter:(void (^)(UIViewController * _Nonnull))alertPresenter pickerPresenter:(void (^)(UIViewController * _Nonnull))pickerPresenter {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Source" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([CMPPhotoVideoManager.shared isSourceAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [CMPPhotoVideoManager.shared requestPhotoLibraryAccessWithCompletion:^(BOOL success) {
                if (success) {
                    UIImagePickerController *vc = [CMPPhotoVideoManager.shared imagePickerControllerForType:UIImagePickerControllerSourceTypePhotoLibrary delegate:self];
                    pickerPresenter(vc);
                } else {
                    [CMPPhotoVideoManager.shared permissionAlertWithTitle:@"Unable to access the Photo Library" message: @"To enable access, go to Settings > Privacy > Photo Library and turn on Photo Library access for this app." presenter:^(UIViewController * _Nonnull vc) {
                        alertPresenter(vc);
                    }];
                }
            }];
        }];
        [alert addAction:alertAction];
    }
    
    if ([CMPPhotoVideoManager.shared isSourceAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [CMPPhotoVideoManager.shared requestCameraAccessWithCompletion:^(BOOL success) {
                if (success) {
                    UIImagePickerController *vc = [CMPPhotoVideoManager.shared imagePickerControllerForType:UIImagePickerControllerSourceTypeCamera delegate:self];
                    pickerPresenter(vc);
                } else {
                    [CMPPhotoVideoManager.shared permissionAlertWithTitle:@"Unable to access the Camera" message: @"To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app." presenter:^(UIViewController * _Nonnull vc) {
                        alertPresenter(vc);
                    }];
                }
            }];
        }];
        [alert addAction:alertAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    
    presenter(alert);
}

- (void)showPhotoCropControllerWithImage:(UIImage *)image presenter:(void (^)(UIViewController * _Nonnull))presenter {
    CMPPhotoCropViewModel *vm = [[CMPPhotoCropViewModel alloc] initWithImage:image];
    CMPPhotoCropViewController *vc = [[CMPPhotoCropViewController alloc] initWithViewModel:vm];
    presenter(vc);
}

#pragma mark - CMPEventDelegate

- (void)client:(CMPComapiClient *)client didReceiveEvent:(CMPEvent *)event {
    __weak typeof(self) weakSelf = self;
    switch (event.type) {
        case CMPEventTypeConversationMessageSent: {
            CMPConversationMessageEventSent *e = (CMPConversationMessageEventSent *)event;
            NSString *messageID = e.payload.messageID;
            NSString *profileID = e.payload.context.from.id;
            BOOL isMyOwn = [profileID isEqualToString:_client.profileID];
            
            [self markDelivered:messageID completion:^(NSError * _Nullable err) {
                if (err) {
                    NSLog(@"%@", err);
                } else {
                    [self getMessagesWithCompletion:^(NSArray<CMPMessage *> * _Nullable messages, NSError * _Nullable err) {
                        if (err) {
                            NSLog(@"%@", err);
                            if (weakSelf.shouldReloadMessages) {
                                weakSelf.shouldReloadMessages(!isMyOwn);
                            }
                        } else {
                            weakSelf.messages = [NSMutableArray arrayWithArray:messages];
                            if (weakSelf.shouldReloadMessages) {
                                weakSelf.shouldReloadMessages(!isMyOwn);
                            }
                        }
                    }];
                }
            }];

            break;
        }
        case CMPEventTypeConversationParticipantTypingOff:
            break;
        case CMPEventTypeConversationParticipantTyping:
            break;
        case CMPEventTypeConversationMessageDelivered: {
            CMPConversationMessageEventDelivered *sentEvent = (CMPConversationMessageEventDelivered *)event;
            NSString *messageID = sentEvent.payload.messageID;
            NSString *profileID = sentEvent.payload.profileID;
            NSInteger idx = [self indexForMessageWithID:messageID];
            if (idx >= 0) {
                NSMutableDictionary<NSString *, CMPMessageStatus *> *statuses = [NSMutableDictionary dictionaryWithDictionary:weakSelf.messages[idx].statusUpdates];
                statuses[profileID] = [[CMPMessageStatus alloc] initWithStatus:CMPMessageDeliveryStatusDelivered timestamp:[NSDate date]];
                _messages[idx].statusUpdates = statuses;
            }
            if (weakSelf.shouldReloadMessageAtIndex) {
                weakSelf.shouldReloadMessageAtIndex(idx);
            }
            [self markRead:messageID completion:^(NSError * _Nullable err) {
                if (err) {
                    NSLog(@"%@", err);
                } else {
                    
//                    [self getMessagesWithCompletion:^(NSArray<CMPMessage *> * _Nullable messages, NSError * _Nullable err) {
//                        if (err) {
//                            NSLog(@"%@", err);
//                            if (weakSelf.shouldReloadMessageAtIndex) {
//                                weakSelf.shouldReloadMessageAtIndex([weakSelf indexForMessageWithID:messageID]);
//                            }
//                        } else {
//                            weakSelf.messages = [NSMutableArray arrayWithArray:messages];
//                            if (weakSelf.shouldReloadMessageAtIndex) {
//                                weakSelf.shouldReloadMessageAtIndex([weakSelf indexForMessageWithID:messageID]);
//                            }
//                        }
//                    }];
                }
            }];
            
            break;
        }
        case CMPEventTypeConversationMessageRead: {
            CMPConversationMessageEventRead *sentEvent = (CMPConversationMessageEventRead *)event;
            NSString *messageID = sentEvent.payload.messageID;
            NSString *profileID = sentEvent.payload.profileID;
            NSInteger idx = [self indexForMessageWithID:messageID];
            if (idx >= 0) {
                NSMutableDictionary<NSString *, CMPMessageStatus *> *statuses = [NSMutableDictionary dictionaryWithDictionary:weakSelf.messages[idx].statusUpdates];
                statuses[profileID] = [[CMPMessageStatus alloc] initWithStatus:CMPMessageDeliveryStatusRead timestamp:[NSDate date]];
                _messages[idx].statusUpdates = statuses;
            }
            if (weakSelf.shouldReloadMessageAtIndex) {
                weakSelf.shouldReloadMessageAtIndex(idx);
            }
//            [self getMessagesWithCompletion:^(NSArray<CMPMessage *> * _Nullable messages, NSError * _Nullable err) {
//                if (err) {
//                    NSLog(@"%@", err);
//                    if (weakSelf.shouldReloadMessageAtIndex) {
//                        weakSelf.shouldReloadMessageAtIndex([weakSelf indexForMessageWithID:messageID]);
//                    }
//                } else {
//                    weakSelf.messages = [NSMutableArray arrayWithArray:messages];
//                    if (weakSelf.shouldReloadMessageAtIndex) {
//                        weakSelf.shouldReloadMessageAtIndex([weakSelf indexForMessageWithID:messageID]);
//                    }
//                }
//            }];

            break;
        }
        case CMPEventTypeConversationParticipantRemoved: {
            CMPConversationEventParticipantRemoved *e = (CMPConversationEventParticipantRemoved *)event;
            if (_didDeleteParticipant) {
                _didDeleteParticipant(e.payload.profileID);
            }
            break;
        }
        case CMPEventTypeConversationDelete: {
            CMPConversationEventDelete *e = (CMPConversationEventDelete *)event;
            if (_didDeleteConversation) {
                _didDeleteConversation(e.conversationID);
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate & UINavigationControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *editedImage = info[UIImagePickerControllerEditedImage];
        if (editedImage) {
            if (self.didTakeNewPhoto) {
                self.didTakeNewPhoto([editedImage resizeToScreenSize]);
            }
            return;
        }
        UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
        if (originalImage) {
            if (self.didTakeNewPhoto) {
                self.didTakeNewPhoto([originalImage resizeToScreenSize]);
            }
            return;
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
