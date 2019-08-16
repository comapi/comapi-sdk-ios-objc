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

#import "CMPRequestTemplate.h"
#import "CMPHTTPRequestTemplate.h"

@class CMPProfile;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(UpdateProfileTemplate)
@interface CMPUpdateProfileTemplate : CMPRequestTemplate <CMPHTTPRequestTemplate>

@property (nonatomic, strong, nullable) NSString *eTag;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *profileID;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *attributes;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID profileID:(NSString *)profileID token:(NSString *)token eTag:(nullable NSString *)eTag attributes:(NSDictionary<NSString *, NSString *> *)attributes;

@end

NS_ASSUME_NONNULL_END

