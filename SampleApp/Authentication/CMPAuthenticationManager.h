//
//  CMPAuthenticationManager.h
//  SampleApp
//
//  Created by Dominik Kowalski on 04/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMPAuthenticationManager : NSObject

+ (NSString *)generateTokenForNonce:(NSString *)nonce profileID:(NSString *)profileID issuer:(NSString *)issuer audience:(NSString *)audience secret:(NSString *)secret;

@end
