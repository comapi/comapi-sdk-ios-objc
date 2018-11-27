//
//  CMPContentUploadTemplate.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 09/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"
#import "CMPContentData.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ContentUploadTemplate)
@interface CMPContentUploadTemplate : CMPRequestTemplate <CMPHTTPStreamableRequestTemplate>

@property (nonatomic, strong) CMPContentData *content;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong, nullable) NSString *folder;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID content:(CMPContentData *)content folder:(nullable NSString *)folder token:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
