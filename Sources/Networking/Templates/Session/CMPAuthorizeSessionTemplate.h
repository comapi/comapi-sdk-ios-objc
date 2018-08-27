//
//  CMPAuthorizationSessionTemplate.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 23/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"
#import "CMPAuthorizeSessionBody.h"

@interface CMPAuthorizeSessionTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, nonnull, strong) CMPAuthorizeSessionBody *body;

@end
