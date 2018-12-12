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

#import "CMPRoles.h"
#import "CMPConversationParticipant.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(NewConversation)
@interface CMPNewConversation : NSObject <CMPJSONEncoding>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSString *conversationDescription;
@property (nonatomic, strong, nullable) CMPRoles *roles;
@property (nonatomic, strong, nullable) NSArray<CMPConversationParticipant *> *participants;
@property (nonatomic, strong, nullable) NSNumber *isPublic;

- (instancetype)initWithID:(nullable NSString *)ID name:(nullable NSString *)name description:(nullable NSString *)descirption roles:(nullable CMPRoles *)roles participants:(nullable NSArray<CMPConversationParticipant *> *)participants isPublic:(nullable NSNumber *)isPublic;

@end

NS_ASSUME_NONNULL_END
