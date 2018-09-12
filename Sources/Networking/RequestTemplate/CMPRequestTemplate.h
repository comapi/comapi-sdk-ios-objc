//
//  RequestTemplate.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 17/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPHTTPHeader.h"
#import "CMPErrors.h"
#import "CMPConstants.h"
#import "NSURLResponse+CMPUtility.h"
#import "CMPRequestPerformer.h"
#import "CMPHTTPRequestTemplate.h"
#import "CMPLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPRequestTemplate : NSObject

@property (nonatomic, strong) NSString *apiSpaceID;
@property (nonatomic, strong) NSString *scheme;
@property (nonatomic, strong) NSString *host;
@property (nonatomic) NSUInteger port;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID;
- (NSURLRequest *)requestFromHTTPRequestTemplate:(id<CMPHTTPRequestTemplate>)template;

@end

NS_ASSUME_NONNULL_END

