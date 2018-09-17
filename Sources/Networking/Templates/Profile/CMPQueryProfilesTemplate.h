//
//  CMPQueryProfilesTemplate.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 12/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"
#import "CMPProfile.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPQueryProfilesTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, strong) NSString *queryString;
@property (nonatomic, strong) NSString *token;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID token:(NSString *)token queryString:(NSString *)queryString;

@end

NS_ASSUME_NONNULL_END
