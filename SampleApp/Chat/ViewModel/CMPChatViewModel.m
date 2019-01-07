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
#import "CMPConversationMessageEvents.h"
#import "CMPPhotoVideoManager.h"
#import "UIImage+CMPUtilities.h"

@implementation CMPChatViewModel

- (instancetype)initWithClient:(CMPComapiClient *)client conversation:(CMPConversation *)conversation {
    self = [super init];
    
    if (self) {
        self.client = client;
        self.conversation = conversation;
        self.messages = @[];
        self.downloader = [[CMPImageDownloader alloc] init];
        
        [self.client addEventDelegate:self];
    }
    
    return self;
}

- (void)getMessagesWithCompletion:(void (^)(NSArray<CMPMessage *> * _Nullable, NSError * _Nullable))completion {
    __weak typeof(self) weakSelf = self;
    [self.client.services.messaging getMessagesWithConversationID:self.conversation.id limit:100 from:0 completion:^(CMPResult<CMPGetMessagesResult *> *result) {
        if (result.error) {
            completion(nil, result.error);
        } else {
            weakSelf.messages = result.object.messages ? result.object.messages : @[];
            completion(weakSelf.messages, nil);
        }
    }];
}

- (void)sendTextMessage:(NSString *)message completion:(void (^)(NSError * _Nullable))completion {
    NSDictionary<NSString *, id> *metadata = @{@"myMessageID" : @"123"};
    CMPMessagePart *part = [[CMPMessagePart alloc] initWithName:@"" type:@"text/plain" url:nil data:message size:[NSNumber numberWithUnsignedLong:sizeof(message.UTF8String)]];
    CMPSendableMessage *sendableMessage = [[CMPSendableMessage alloc] initWithMetadata:metadata parts:@[part] alert:nil];
    [self.client.services.messaging sendMessage:sendableMessage toConversationWithID:self.conversation.id completion:^(CMPResult<CMPSendMessagesResult *> *result) {
        if (result.error) {
            completion(result.error);
        } else {
            completion(nil);
        }
    }];
}

- (void)uploadContent:(CMPContentData *)content completion:(void (^)(CMPContentUploadResult * _Nullable, NSError * _Nullable))completion {
    [self.client.services.messaging uploadContent:content folder:nil completion:^(CMPResult<CMPContentUploadResult *> *result) {
        if (result.error) {
            completion(nil, result.error);
        } else {
            completion(result.object, nil);
        }
    }];
}

- (void)sendImageWithUploadResult:(CMPContentUploadResult *)result completion:(void (^)(NSError * _Nullable))completion {
    NSDictionary<NSString *, id> *metadata = @{@"myMessageID" : @"123"};
    CMPMessagePart *part = [[CMPMessagePart alloc] initWithName:@"image" type:result.type url:result.url data:nil size:nil];
    CMPSendableMessage *message = [[CMPSendableMessage alloc] initWithMetadata:metadata parts:@[part] alert:nil];
    
    [self.client.services.messaging sendMessage:message toConversationWithID:self.conversation.id completion:^(CMPResult<CMPSendMessagesResult *> *result) {
        if (result.error) {
            completion(result.error);
        } else {
            completion(nil);
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
    switch (event.type) {
        case CMPEventTypeConversationMessageSent: {
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
            CMPMessage *message = [[CMPMessage alloc] initWithID:messageID sentEventID:sentEvent.eventID metadata:metadata context:context parts:parts statusUpdates:nil];
            self.messages = [self.messages arrayByAddingObject:message];
            if (self.didReceiveMessage) {
                self.didReceiveMessage();
            }
            break;
        }
            
        case CMPEventTypeConversationParticipantTypingOff:
            break;
        case CMPEventTypeConversationParticipantTyping:
            break;
        case CMPEventTypeConversationMessageRead:
            break;
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
