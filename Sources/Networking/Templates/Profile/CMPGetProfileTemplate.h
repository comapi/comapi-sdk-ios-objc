//
//  CMPGetProfileTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 11/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"
#import "CMPProfile.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(GetProfileTemplate)
@interface CMPGetProfileTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, strong) NSString *profileID;
@property (nonatomic, strong) NSString *token;

-(instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID profileID:(NSString *)profileID token:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
