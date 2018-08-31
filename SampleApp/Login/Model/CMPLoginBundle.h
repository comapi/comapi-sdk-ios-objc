//
//  CMPLoginBundle.h
//  SampleApp
//
//  Created by Dominik Kowalski on 31/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMPLoginBundle : NSObject <NSCoding>

@property (nonatomic, strong, nullable) NSString *apiSpaceID;
@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSString *issuer;
@property (nonatomic, strong, nullable) NSString *audience;
@property (nonatomic, strong, nullable) NSString *secret;

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID profileID:(NSString *)profileID issuer:(NSString *)issuer audience:(NSString *)audience secret:(NSString *)secret;

- (BOOL)isValid;

@end
