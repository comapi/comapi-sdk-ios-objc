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
#import "CMPPhotoCropViewController.h"
#import "CMPImageDownloader.h"

#import <UIKit/UIKit.h>

@import CMPComapiFoundation;

NS_ASSUME_NONNULL_BEGIN

@interface CMPChatViewModel : NSObject <CMPEventDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (atomic, strong) NSMutableArray<CMPMessage *> *messages;
@property (atomic, strong) NSMutableArray<CMPConversationParticipant *> *participants;
@property (atomic, strong) NSMutableArray<UIImage *> *imageAttachments;


@property (nonatomic, strong) CMPComapiClient *client;
@property (nonatomic, strong) CMPConversation *conversation;

@property (nonatomic, strong) CMPImageDownloader *downloader;

@property (nonatomic, copy) void(^shouldReloadMessageAtIndex)(NSInteger);
@property (nonatomic, copy) void(^shouldReloadMessages)(BOOL);
@property (nonatomic, copy) void(^shouldReloadAttachments)(void);
@property (nonatomic, copy) void(^didDeleteParticipant)(NSString *);
@property (nonatomic, copy) void(^didDeleteConversation)(NSString *);
@property (nonatomic, copy) void(^didTakeNewPhoto)(UIImage *);

- (instancetype)initWithClient:(CMPComapiClient *)client conversation:(CMPConversation *)conversation;

- (void)getParticipantsWithCompletion:(void(^)(NSArray<CMPConversationParticipant *> * _Nullable, NSError * _Nullable))completion;

- (void)getMessagesWithCompletion:(void(^)(NSArray<CMPMessage *> * _Nullable, NSError * _Nullable))completion;
- (void)addImageAttachment:(UIImage *)image;
- (void)sendMessage:(nullable NSString *)message completion:(void (^)(NSError * _Nullable))completion;
- (void)showPhotoSourceControllerWithPresenter:(void (^)(UIViewController *))presenter alertPresenter:(void (^)(UIViewController *))alertPresenter pickerPresenter:(void (^)(UIViewController *))pickerPresenter;
- (void)showPhotoCropControllerWithImage:(UIImage *)image presenter:(void(^)(UIViewController *))presenter;

- (void)markUnreadWithCompletion:(void(^)(BOOL, NSError * _Nullable))completion;
- (void)markRead:(NSString *)messageID completion:(void(^)(NSError * _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
