//
//  CMPClient.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 21/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPComapiClient.h"
#import "CMPRequestManager.h"


@interface CMPComapiClient ()

@property (nonatomic, strong) NSString *apiSpaceID;
@property (nonatomic, strong) CMPRequestManager *requestManager;
@property (nonatomic, strong) CMPAPIConfiguration *apiConfiguration;
@property (nonatomic, strong) NSString* apiSpaceID;
@property (nonatomic, strong) NSString* apiSpaceID;

@end

@implementation CMPComapiClient

-(instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate apiConfiguration:(CMPAPIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self
    }
}

@end
