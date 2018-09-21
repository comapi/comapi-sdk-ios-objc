//
//  HTTPHeader.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 20/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMPHTTPHeader : NSObject

@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *field;

- (instancetype)initWithField:(NSString *)field value:(NSString *)value;

@end
