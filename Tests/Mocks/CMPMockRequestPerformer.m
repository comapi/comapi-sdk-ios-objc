//
//  CMPMockRequestPerformer.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 19/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPMockRequestPerformer.h"

@implementation CMPMockRequestResult

- (instancetype)initWithData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error {
    self = [super init];
    
    if (self) {
        self.data = data;
        self.response = response;
        self.error = error;
    }
    
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    CMPMockRequestResult *copy = [[CMPMockRequestResult alloc] init];
    
    copy.data = self.data;
    copy.response = self.response;
    copy.error = self.error;
    
    return copy;
}

@end

@implementation CMPMockRequestPerformer

- (instancetype)initWithSessionAndAuth {
    self = [super init];
    
    if (self) {
        //self.receivedRequests = [NSMutableArray new];
        self.completionValues = [NSMutableArray new];
        
        CMPMockRequestResult *challenge = [[CMPMockRequestResult alloc] initWithData:[CMPResourceLoader loadJSONWithName:@"AuthenticationChallenge"] response:[NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]] error:nil];
        CMPMockRequestResult *auth = [[CMPMockRequestResult alloc] initWithData:[CMPResourceLoader loadJSONWithName:@"SessionAuth"] response:[NSHTTPURLResponse mockedWithURL:[CMPTestMocks mockBaseURL]] error:nil];
        
        [self.completionValues addObject:challenge];
        [self.completionValues addObject:auth];
    }
    
    return self;
}


- (void)performRequest:(NSURLRequest *)request completion:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completion {
    if (self.completionValues.count == 0) {
        completion(nil, nil, [[NSError alloc] initWithDomain:[CMPTestMocks mockErrorDomain] code:[CMPTestMocks mockStatusCode] userInfo:@{}]);
    } else {
        CMPMockRequestResult *completionValue = [[self.completionValues firstObject] copy];
        [self.completionValues removeObjectAtIndex:0];
        completion(completionValue.data, completionValue.response, completionValue.error);
    }
    
}

@end
