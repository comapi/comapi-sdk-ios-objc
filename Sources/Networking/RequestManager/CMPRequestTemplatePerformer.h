//
//  CMPRequestTemplatePerformer.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPRequestTemplate.h"

@interface CMPRequestTemplatePerformer : NSObject

-(void)performFromTemplate:(CMPRequestTemplate<CMPHTTPRequestTemplate>*)template completion:(void (^)(id, NSError *))completion;

@end
