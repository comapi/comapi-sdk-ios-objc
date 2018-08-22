//
//  CMPRequestTemplatePerformer.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplatePerformer.h"
#import "CMPRequestPerformer.h"
#import "NSURLResponse+CMPUtility.h"
#import "CMPErrors.h"

@interface CMPRequestTemplatePerformer ()

@property (nonatomic, strong) CMPRequestPerformer *requestPerformer;

@end

@implementation CMPRequestTemplatePerformer

-(void)performFromTemplate:(CMPRequestTemplate<CMPHTTPRequestTemplate>*)template completion:(void (^)(id, NSError *))completion {
    
    NSURLRequest *request = [template requestFromHTTPTemplate:template];
    if (request == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, [CMPErrors errorWithStatus:CMPRequestTemplateErrorRequestCreationFailed underlyingError:nil]);
        });
    }
    
    [self.requestPerformer performRequest:request completion:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data != nil && response != nil) {
            if ([response httpStatusCode] == 401) {
                completion(nil, [CMPErrors errorWithStatus:CMPRequestTemplateErrorUnauthorized underlyingError:error]);
            } else {
                
                
            }
        } else {
            completion(nil, error);
        }
    }];
}

@end
