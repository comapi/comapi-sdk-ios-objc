//
//  CMPUpdateProfileTemplate.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 12/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"
#import "CMPProfile.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPUpdateProfileTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, strong, nullable) NSString *eTag;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *profileID;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *attributes;

-(instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID profileID:(NSString *)profileID token:(NSString *)token eTag:(nullable NSString *)eTag attributes:(NSDictionary<NSString *, NSString *> *)attributes;

@end

NS_ASSUME_NONNULL_END

