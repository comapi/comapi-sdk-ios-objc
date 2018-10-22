//
//  CMPPhotoVideoManager.h
//  SampleApp
//
//  Created by Dominik Kowalski on 22/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMPPhotoVideoManager : NSObject

@property (class, nonatomic, strong, readonly) CMPPhotoVideoManager *shared;

- (void)requestPhotoLibraryAccessWithCompletion:(void(^)(BOOL))completion;
- (void)requestCameraAccessWithCompletion:(void(^)(BOOL))completion;
- (BOOL)isSourceAvailable:(UIImagePickerControllerSourceType)source;
- (void)saveImage:(UIImage *)image album:(PHAssetCollection *)album withCompletion:(void(^)(NSError * _Nullable))completion;
- (void)createAlbumWithCompletion:(void(^)(PHAssetCollection * _Nullable, NSError * _Nullable))completion;
- (UIImagePickerController *)imagePickerControllerForType:(UIImagePickerControllerSourceType)type delegate:(id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate;
- (void)permissionAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message presenter:(void(^)(UIViewController *))presenter;
@end

NS_ASSUME_NONNULL_END
