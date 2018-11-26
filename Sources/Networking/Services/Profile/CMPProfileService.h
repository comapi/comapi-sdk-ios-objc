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

/**
 @brief Fetches a profile for specified Id.
 @param profileID Id of the searched profile.
 @param completion Block with a result value, the @b object returned is of type @a CMPProfile* or nil if an error occurred.
 */
- (void)getProfileWithProfileID:(NSString *)profileID completion:(void(^)(CMPResult<CMPProfile *> *))completion NS_SWIFT_NAME(getProfile(profileID:completion:));

/**
 @brief Updates a profile for specified Id with listed attributes.
 @param profileID Id of the profile being updated.
 @param attributes Attributes being inserted/updated with respective values.
 @param eTag ETag value that checks if the data we are expecting matches the one on the server (helps prevent conflicts when multiple updates happen simultanously).
 @param completion completion Block with a result value, the @b object returned is of type @a CMPProfile* or nil if an error occurred.
 */
- (void)updateProfileWithProfileID:(NSString *)profileID attributes:(NSDictionary<NSString *, NSString *> *)attributes eTag:(NSString * _Nullable)eTag completion:(void(^)(CMPResult<CMPProfile *> *))completion
    NS_SWIFT_NAME(updateProfile(profileID:attributes:eTag:completion:));

/**
 @brief Patch a profile for specified Id with listed attributes.
 @param profileID Id of the profile being patched.
 @param attributes Attributes being inserted/patched with respective values.
 @param eTag ETag value that checks if the data we are expecting matches the one on the server (helps prevent conflicts when multiple patches happen simultanously).
 @param completion completion Block with a result value, the @b object returned is of type @a CMPProfile* or nil if an error occurred.
 */
- (void)patchProfileWithProfileID:(NSString *)profileID attributes:(NSDictionary<NSString *, NSString *> *)attributes eTag:(NSString * _Nullable)eTag completion:(void(^)(CMPResult<CMPProfile *> *))completion NS_SWIFT_NAME(patchProfile(profileID:attributes:eTag:completion:));

/**
 @brief Queries profiles with a query builder.
 @param queryElements Filter criteria for searched profiles.
 @param completion Block with a result value, the @b object returned is of type @a NSArray<CMPProfile*>* or nil if an error occurred.
 */
- (void)queryProfilesWithQueryElements:(NSArray<CMPQueryElements *> *)queryElements completion:(void (^)(CMPResult<NSArray<CMPProfile *> *> *))completion
    NS_SWIFT_NAME(queryProfiles(queryElements:completion:));

@end

NS_SWIFT_NAME(ProfileService)
@interface CMPProfileService : CMPBaseService <CMPProfileServiceable>

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
