//
//  APNSDetails.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 30/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPJSONEncoding.h"

@interface CMPAPNSDetails : NSObject <CMPJSONEncoding>

@property (nonatomic, strong, nullable) NSString *bundleID;
@property (nonatomic, strong, nullable) NSString *environment;
@property (nonatomic, strong, nullable) NSString *token;

- (instancetype)initWithBundleID:(NSString *)bundleID environment:(NSString *)environment token:(NSString *)token;

@end
