//
//  SessionAuth.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 14/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPSession.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPSessionAuth : NSObject

@property (nonatomic, nullable) NSString* token;
@property (nonatomic, nullable) CMPSession* session;

- (instancetype)initWithJSON:(NSDictionary*)json;

@end

NS_ASSUME_NONNULL_END
