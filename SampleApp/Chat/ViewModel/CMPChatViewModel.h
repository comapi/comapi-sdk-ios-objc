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

#import "CMPComapiClient.h"
#import "CMPPhotoCropViewController.h"
#import "CMPImageDownloader.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMPChatViewModel : NSObject <CMPEventDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) CMPComapiClient *client;
@property (nonatomic, strong) CMPConversation *conversation;
@property (nonatomic, strong) NSArray<CMPMessage *> *messages;
@property (nonatomic, strong) CMPImageDownloader *downloader;

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
