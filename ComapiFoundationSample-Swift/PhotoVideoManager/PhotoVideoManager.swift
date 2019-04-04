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

import UIKit
import Photos

class PhotoVideoManager: NSObject {
    
    static let shared = PhotoVideoManager()
    
    private override init() {}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func requestPhotoLibraryAccess(completion: ((Bool) -> Void)?) {
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    completion?(true)
                default:
                    completion?(false)
                }
            }
        }
    }
    
    func requestCameraAccess(completion: ((Bool) -> Void)?) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            DispatchQueue.main.async {
                if response {
                    completion?(true)
                } else {
                    completion?(false)
                }
            }
        }
    }
    
    func isSourceAvailable(source: UIImagePickerController.SourceType) -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(source)
    }
    
    func saveImage(_ image: UIImage, toAlbum album: PHAssetCollection,  completion: ((Error?) -> Void)?) {
        PHPhotoLibrary.shared().performChanges({
            let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceholder = assetRequest.placeholderForCreatedAsset
            let photosAsset = PHAsset.fetchAssets(in: album, options: nil)
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: album, assets: photosAsset)
            albumChangeRequest?.addAssets([assetPlaceholder!] as NSArray)
        }, completionHandler: { success, error in
            DispatchQueue.main.async {
                
                if let _completion = completion {
                    if let _error = error {
                        _completion(_error)
                        return
                    }
                    
                    _completion(nil)
                }
            }
        })
    }
    
    func createAlbum(completion: ((PHAssetCollection?, Error?) -> Void)?) {
        var albumPlaceholder: PHObjectPlaceholder?
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", "SampleApp")
        let collection : PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let album = collection.firstObject {
            if let _completion = completion {
                _completion(album, nil)
            }
        } else {
            PHPhotoLibrary.shared().performChanges({
                let createAlbumRequest : PHAssetCollectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "Befriend")
                albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }, completionHandler: { success, error in
                DispatchQueue.main.async {
                    if error != nil {
                        completion?(nil, error)
                        return
                    }
                    
                    if success {
                        guard let placeholder = albumPlaceholder else { return }
                        let collectionFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
                        let album = collectionFetchResult.firstObject
                        if album != nil {
                            completion?(album!, nil)
                        }
                    }
                }
            })
        }
    }
    
    func imagePickerController(type: UIImagePickerController.SourceType, delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.modalPresentationStyle = .fullScreen
        vc.sourceType = type
        vc.delegate = delegate
        vc.navigationBar.barTintColor = .gray
        
        return vc
    }
    
    func permissionAlert(withTitle title: String, message: String, alertPresenter: (UIViewController) -> ()) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    
                })
            }
        })
        alert.addAction(settingsAction)
        
        alertPresenter(alert)
    }
}
