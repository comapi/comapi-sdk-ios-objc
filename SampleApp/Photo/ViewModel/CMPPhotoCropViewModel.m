//
//  CMPPhotoCropViewModel.m
//  SampleApp
//
//  Created by Dominik Kowalski on 19/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPPhotoCropViewModel.h"

@implementation CMPPhotoCropViewModel

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    
    if (self) {
        self.image = image;
    }
    
    return self;
}

- (NSData *)prepareCroppedImage:(UIImage *)image {
    return UIImageJPEGRepresentation(image, 0.6);
}

@end


//class PhotoCropViewModel: NSObject {
//
//    var image: UIImage
//
//    init(image: UIImage) {
//        self.image = image
//
//        super.init()
//    }
//
//    private func convertToJPEG(croppedImage: UIImage) -> Data? {
//        if let jpeg = UIImageJPEGRepresentation(croppedImage, 0.6) {
//            return jpeg
//        }
//
//            return nil
//            }
//
//    func prepare(croppedImage: UIImage, completion: ((Data) -> ())?, failure: (() -> ())?) {
//        if let data = convertToJPEG(croppedImage: croppedImage) {
//            completion?(data)
//        } else {
//            failure?()
//        }
//    }
//}
