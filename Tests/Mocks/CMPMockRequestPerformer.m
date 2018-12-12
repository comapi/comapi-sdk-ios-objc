//
// The MIT License (MIT)
// Copyright (c) 2017 Comapi (trading name of Dynmark International Limited)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
