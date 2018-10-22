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

#import "CMPRequestPerformer.h"
#import "CMPHTTPRequestTemplate.h"
#import "CMPHTTPHeader.h"
#import "CMPConstants.h"
#import "CMPErrors.h"
#import "NSURLResponse+CMPUtility.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(RequestTemplate)
@interface CMPRequestTemplate : NSObject

@property (nonatomic, strong) NSString *apiSpaceID;
@property (nonatomic, strong) NSString *scheme;
@property (nonatomic, strong) NSString *host;
@property (nonatomic) NSUInteger port;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID;
- (NSURLRequest *)requestFromHTTPRequestTemplate:(id<CMPHTTPRequestTemplate>)template;

@end

NS_ASSUME_NONNULL_END

