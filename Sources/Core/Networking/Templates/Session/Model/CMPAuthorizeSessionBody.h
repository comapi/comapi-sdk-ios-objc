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

#import "CMPJSONEncoding.h"
#import "CMPAPNSDetailsBody.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AuthorizeSessionBody)
@interface CMPAuthorizeSessionBody : NSObject <CMPJSONEncoding>

@property (nonatomic, strong) NSString *authenticationID;
@property (nonatomic, strong) NSString *authenticationToken;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *platform;
@property (nonatomic, strong) NSString *platformVersion;
@property (nonatomic, strong) NSString *sdkType;
@property (nonatomic, strong) NSString *sdkVersion;
@property (nonatomic, strong) CMPAPNSDetailsBody *push;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAuthenticationID:(NSString *)authenticationID authenticationToken:(NSString *)authenticationToken;
- (instancetype)initWithAuthenticationID:(NSString *)authenticationID authenticationToken:(NSString *)authenticationToken pushDetails:(CMPAPNSDetailsBody *) pushDetails;
- (instancetype)initWithAuthenticationID:(NSString *)authenticationID authenticationToken:(NSString *)authenticationToken deviceID:(NSString *)deviceID platform:(NSString *)platform platformVersion:(NSString *)platformVersion sdkType:(NSString *)sdkType sdkVersion:(NSString *)sdkVersion;

@end

NS_ASSUME_NONNULL_END
