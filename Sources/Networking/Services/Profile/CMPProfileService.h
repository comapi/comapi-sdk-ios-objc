//
//  CMPProfileService.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 23/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseService.h"
#import "CMPQueryBuilder.h"
#import "CMPProfile.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ProfileServiceable)
@protocol CMPProfileServiceable <NSObject>

- (void)getProfileWithProfileID:(NSString *)profileID completion:(void(^)(CMPResult<CMPProfile *> *))completion NS_SWIFT_NAME(getProfile(profileID:completion:));
- (void)updateProfileWithProfileID:(NSString *)profileID attributes:(NSDictionary<NSString *, NSString *> *)attributes eTag:(NSString * _Nullable)eTag completion:(void(^)(CMPResult<CMPProfile *> *))completion
    NS_SWIFT_NAME(updateProfile(profileID:attributes:eTag:completion:));
- (void)patchProfileWithProfileID:(NSString *)profileID attributes:(NSDictionary<NSString *, NSString *> *)attributes eTag:(NSString * _Nullable)eTag completion:(void(^)(CMPResult<CMPProfile *> *))completion NS_SWIFT_NAME(patchProfile(profileID:attributes:eTag:completion:));
- (void)queryProfilesWithQueryElements:(NSArray<CMPQueryElements *> *)queryElements completion:(void (^)(CMPResult<NSArray<CMPProfile *> *> *))completion
    NS_SWIFT_NAME(queryProfiles(queryElements:completion:));

@end

NS_SWIFT_NAME(ProfileService)
@interface CMPProfileService : CMPBaseService <CMPProfileServiceable>

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
