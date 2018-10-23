//
//  CMPImageDownloader.h
//  SampleApp
//
//  Created by Dominik Kowalski on 23/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMPImageDownloader : NSObject

- (void)downloadFromURL:(NSURL *)url completion:(void(^)(UIImage * _Nullable, NSError * _Nullable))completion;
- (void)cancelAllOperations;

@end

NS_ASSUME_NONNULL_END
