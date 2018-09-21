//
//  CMPConfig.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAPIConfiguration.h"
#import "CMPComapiConfig.h"
#import "CMPAuthenticationDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPComapiConfig : NSObject

@property (nonatomic, strong, readonly) NSString* id;
@property (nonatomic, strong, readonly) id<CMPAuthenticationDelegate> authDelegate;
@property (nonatomic, strong) CMPAPIConfiguration *apiConfig;

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)authenticationDelegate;

@end

NS_ASSUME_NONNULL_END
