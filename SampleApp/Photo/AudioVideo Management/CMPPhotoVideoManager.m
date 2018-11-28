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

#import "CMPPhotoVideoManager.h"

@implementation CMPPhotoVideoManager

+ (CMPPhotoVideoManager *)shared {
    static CMPPhotoVideoManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)requestPhotoLibraryAccessWithCompletion:(void (^)(BOOL))completion {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusAuthorized) {
                completion(YES);
            } else {
                completion(NO);
            }
        });
    }];
}

- (void)requestCameraAccessWithCompletion:(void (^)(BOOL))completion {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(granted);
        });
    }];
}

- (BOOL)isSourceAvailable:(UIImagePickerControllerSourceType)source {
    return [UIImagePickerController isSourceTypeAvailable:source];
}

- (void)saveImage:(UIImage *)image album:(PHAssetCollection *)album withCompletion:(void (^)(NSError * _Nullable))completion {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCreationRequest *assetRequest = [PHAssetCreationRequest creationRequestForAssetFromImage:image];
        PHObjectPlaceholder *assetPlaceholder = [assetRequest placeholderForCreatedAsset];
        PHFetchResult<PHAsset *> *photoAsset = [PHAsset fetchAssetsInAssetCollection:album options:nil];
        PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album assets:photoAsset];
        [albumChangeRequest addAssets:@[assetPlaceholder]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completion(error);
            } else {
                completion(nil);
            }
        });
    }];
}

- (void)createAlbumWithCompletion:(void (^)(PHAssetCollection * _Nullable, NSError * _Nullable))completion {
    __block PHObjectPlaceholder *albumPlaceholder;
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title = %@", @"SampleApp"];
    PHFetchResult<PHAssetCollection *> *collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:fetchOptions];
    if (collection.firstObject) {
        completion(collection.firstObject, nil);
    } else {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest * createAlbumRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"SampleApp"];
            albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection;
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error || !success) {
                    completion(nil, error);
                } else {
                    PHFetchResult<PHAssetCollection *> *result = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[albumPlaceholder.localIdentifier] options:nil];
                    if (result.firstObject) {
                        completion(result.firstObject, nil);
                    }
                }
            });
        }];
    }
}

- (UIImagePickerController *)imagePickerControllerForType:(UIImagePickerControllerSourceType)type delegate:(id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate {
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.sourceType = type;
    vc.delegate = delegate;
    vc.navigationBar.barTintColor = UIColor.grayColor;
    return vc;
}

- (void)permissionAlertWithTitle:(NSString *)title message:(NSString *)message presenter:(void (^)(UIViewController * _Nonnull))presenter {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([UIApplication.sharedApplication canOpenURL:url]) {
            [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];
        }
    }];
    
    [alert addAction:okAction];
    [alert addAction:settingsAction];
    
    presenter(alert);
}

@end
