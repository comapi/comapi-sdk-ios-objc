//
//  CMPImageDownloader.m
//  SampleApp
//
//  Created by Dominik Kowalski on 23/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPImageDownloader.h"

@interface CMPImageDownloader ()

@property (nonatomic, strong, readonly) NSOperationQueue *queue;
@property (nonatomic, strong, readonly) NSURLSession *session;

@end

@implementation CMPImageDownloader

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 3;
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        
        _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:_queue];
    }
    
    return self;
}

- (void)downloadFromURL:(NSURL *)url completion:(void (^)(UIImage * _Nullable, NSError * _Nullable))completion {
    NSURLSessionDataTask *task = [_session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
            return;
        } else if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(image, nil);
                });
                return;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, nil);
        });
    }];
    
    [task resume];
}

- (void)cancelAllOperations {
    [_queue cancelAllOperations];
}

@end
