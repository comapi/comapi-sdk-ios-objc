//
//  CMPPhotoVideoManager.m
//  SampleApp
//
//  Created by Dominik Kowalski on 22/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPPhotoVideoManager.h"

@implementation CMPPhotoVideoManager

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


////
////  AVManager.swift
////  SampleApp
////
////  Created by Dominik Kowalski on 02/08/2018.
////  Copyright © 2018 Dominik Kowalski. All rights reserved.
////
//
//import UIKit
//import Photos
//
//class PhotoVideoManager: NSObject {
//
//    static let shared = PhotoVideoManager()
//
//    private override init() {}
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func requestPhotoLibraryAccess(completion: ((Bool) -> Void)?) {
//        PHPhotoLibrary.requestAuthorization { (status) in
//            DispatchQueue.main.async {
//                switch status {
//                case .authorized:
//                    completion?(true)
//                default:
//                    completion?(false)
//                }
//            }
//        }
//    }
//
//    func requestCameraAccess(completion: ((Bool) -> Void)?) {
//        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
//            DispatchQueue.main.async {
//                if response {
//                    completion?(true)
//                } else {
//                    completion?(false)
//                }
//            }
//        }
//    }
//
//    func isSourceAvailable(source: UIImagePickerControllerSourceType) -> Bool {
//        return UIImagePickerController.isSourceTypeAvailable(source)
//    }
//

//

//

//

//}
