//
//  CMPMockRequestPerformer.h
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 19/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPRequestPerforming.h"
#import "NSHTTPURLResponse+CMPTestUtility.h"
#import "CMPTestMocks.h"
#import "CMPResourceLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPMockRequestResult : NSObject <NSCopying>

@property (nonatomic, strong, nullable) NSData *data;
@property (nonatomic, strong, nullable) NSURLResponse *response;
@property (nonatomic, strong, nullable) NSError *error;

- (instancetype)initWithData:(nullable NSData *)data response:(nullable NSURLResponse *)response error:(nullable NSError *)error;

@end

@interface CMPMockRequestPerformer : NSObject <CMPRequestPerforming>

@property (nonatomic, strong) NSMutableArray<NSURLRequest *> *receivedRequests;
@property (nonatomic, strong) NSMutableArray<CMPMockRequestResult *> *completionValues;

- (instancetype)initWithSessionAndAuth;

@end

NS_ASSUME_NONNULL_END
