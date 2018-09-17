//
//  CMPProfileService.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 23/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseService.h"
#import "CMPQueryBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPProfileService : CMPBaseService

@property (nonatomic, strong, nullable) NSString *currentProfileID;

- (void)getProfileForProfileID:(NSString *)profileID completion:(void(^)(CMPRequestTemplateResult *))completion;
- (void)updateProfileForProfileID:(NSString *)profileID attributes:(NSDictionary<NSString *, NSString *> *)attributes eTag:(NSString *)eTag completion:(void(^)(CMPRequestTemplateResult *))completion;
- (void)updateCurrentProfileWithAttributes:(NSDictionary<NSString *, NSString *> *)attributes eTag:(NSString *)eTag completion:(void(^)(CMPRequestTemplateResult *))completion;
- (void)patchProfileForProfileID:(NSString *)profileID attributes:(NSDictionary<NSString *, NSString *> *)attributes eTag:(NSString *)eTag completion:(void(^)(CMPRequestTemplateResult *))completion;
- (void)patchCurrentProfileWithAttributes:(NSDictionary<NSString *, NSString *> *)attributes eTag:(NSString *)eTag completion:(void(^)(CMPRequestTemplateResult *))completion;
- (void)queryProfilesWithQueryElements:(NSArray<CMPQueryElements *> *)queryElements completion:(void (^)(CMPRequestTemplateResult * _Nonnull))completion;

@end

NS_ASSUME_NONNULL_END
