//
//  RequestTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 17/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestPerformer.h"
#import "CMPHTTPRequestTemplate.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(RequestTemplate)
@interface CMPRequestTemplate : NSObject

@property (nonatomic, strong) NSString *apiSpaceID;
@property (nonatomic, strong) NSString *scheme;
@property (nonatomic, strong) NSString *host;
@property (nonatomic) NSUInteger port;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID;
- (NSURLRequest *)requestFromHTTPRequestTemplate:(id<CMPHTTPRequestTemplate>)template;

@end

NS_ASSUME_NONNULL_END

