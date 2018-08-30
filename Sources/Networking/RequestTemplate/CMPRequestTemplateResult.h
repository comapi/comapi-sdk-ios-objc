//
//  CMPRequestTemplateResult.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 29/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMPRequestTemplateResult : NSObject

@property (nonatomic, nullable) id object;
@property (nonatomic, nullable) NSError *error;

- (instancetype)initWithObject:(nullable id)object error:(nullable NSError *)error;

@end
