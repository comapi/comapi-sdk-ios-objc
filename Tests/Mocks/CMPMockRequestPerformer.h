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
