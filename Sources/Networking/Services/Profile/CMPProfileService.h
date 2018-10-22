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

#import "CMPBaseService.h"
#import "CMPQueryBuilder.h"
#import "CMPProfile.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ProfileServiceable)
@protocol CMPProfileServiceable

- (void)getProfileForProfileID:(NSString *)profileID completion:(void(^)(CMPProfile * _Nullable, NSError * _Nullable))completion;
- (void)updateProfileForProfileID:(NSString *)profileID attributes:(NSDictionary<NSString *, NSString *> *)attributes eTag:(NSString * _Nullable)eTag completion:(void(^)(CMPProfile * _Nullable, NSError * _Nullable))completion;
- (void)patchProfileForProfileID:(NSString *)profileID attributes:(NSDictionary<NSString *, NSString *> *)attributes eTag:(NSString * _Nullable)eTag completion:(void(^)(CMPProfile * _Nullable, NSError * _Nullable))completion;
- (void)queryProfilesWithQueryElements:(NSArray<CMPQueryElements *> *)queryElements completion:(void (^)(NSArray<CMPProfile *> * _Nullable, NSError * _Nullable))completion;

@end

NS_SWIFT_NAME(ProfileService)
@interface CMPProfileService : CMPBaseService <CMPProfileServiceable>

@end

NS_ASSUME_NONNULL_END
