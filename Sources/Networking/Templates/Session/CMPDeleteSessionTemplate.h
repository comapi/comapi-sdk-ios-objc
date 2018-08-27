//
//  CMPDeleteSessionTemplate.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 27/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"

@interface CMPDeleteSessionTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *sessionID;

- (instancetype) initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port token:(NSString *)token sessionID:(NSString *)sessionID;

@end
