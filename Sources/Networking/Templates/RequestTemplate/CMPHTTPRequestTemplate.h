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

#import "CMPResult.h"
#import "CMPUtilities.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(HTTPRequestTemplate)
@protocol CMPHTTPRequestTemplate <NSObject>

- (NSString *)httpMethod;
- (NSArray<NSString *> *)pathComponents;
- (nullable NSDictionary<NSString *, NSString *> *) query;
- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders;
- (nullable NSData *)httpBody;

- (CMPResult<id> *)resultFromData:(NSData *)data urlResponse:(NSURLResponse *)response;
- (void)performWithRequestPerformer:(id<CMPRequestPerforming>)performer result:(void(^)(CMPResult<id> *))result;

@end

NS_SWIFT_NAME(HTTPStreamableRequestTemplate)
@protocol CMPHTTPStreamableRequestTemplate <CMPHTTPRequestTemplate>

- (nullable NSInputStream *)httpBodyStream;

@end

NS_ASSUME_NONNULL_END
