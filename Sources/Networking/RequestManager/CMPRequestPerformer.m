//
//  CMPRequestPerformer.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 17/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestPerformer.h"
#import "NSData+CMPUtility.h"
#import "CMPURLResult.h"
#import "CMPLogger.h"

@implementation CMPRequestPerformer 

- (instancetype)init {
    self = [super init];
    if (self) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    return self;
}

- (void)performRequest:(NSURLRequest *)request completion:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completion {
    [[CMPLogger shared] verbose:@[@"will perform request", request]];
    
    if ([request.HTTPMethod isEqualToString:@"POST"] && request.HTTPBodyStream != nil) {
        NSData *data = [[NSData alloc] initWithInputStream:request.HTTPBodyStream];
        NSURLSessionTask *task = [self.session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            CMPURLResult *result = [[CMPURLResult alloc] initWithRequest:request data:data response:response error:error];
            [[CMPLogger shared] verbose:@[@"upload task completed", result]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               completion(data, response, error);
            });
        }];
        
        [task resume];
    } else {
        NSURLSessionTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            CMPURLResult *result = [[CMPURLResult alloc] initWithRequest:request data:data response:response error:error];
            [[CMPLogger shared] verbose:@[@"did finish request", result]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(data, response, error);
            });
        }];
        
        [task resume];
    }
}

@end
