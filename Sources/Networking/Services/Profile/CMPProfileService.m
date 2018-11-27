//
//  CMPProfileService.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 23/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPProfileService.h"
#import "CMPGetProfileTemplate.h"
#import "CMPUpdateProfileTemplate.h"
#import "CMPPatchProfileTemplate.h"
#import "CMPQueryProfilesTemplate.h"

@implementation CMPProfileService

- (void)getProfileWithProfileID:(NSString *)profileID completion:(void (^)(CMPResult<CMPProfile *> *))completion {
    CMPGetProfileTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPGetProfileTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID profileID:profileID token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<CMPProfile *> * result) {
        completion(result);
    }];
}

- (void)updateProfileWithProfileID:(NSString *)profileID attributes:(NSDictionary<NSString *,NSString *> *)attributes eTag:(NSString * _Nullable)eTag completion:(void (^)(CMPResult<CMPProfile *> *))completion {
    CMPUpdateProfileTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPUpdateProfileTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID profileID:profileID token:token eTag:eTag attributes:attributes];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<CMPProfile *> * result) {
        completion(result);
    }];
}

- (void)patchProfileWithProfileID:(NSString *)profileID attributes:(NSDictionary<NSString *,NSString *> *)attributes eTag:(NSString * _Nullable)eTag completion:(void (^)(CMPResult<CMPProfile *> *))completion {
    CMPPatchProfileTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPPatchProfileTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID profileID:profileID token:token eTag:eTag attributes:attributes];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<CMPProfile *> * result) {
        completion(result);
    }];
}

- (void)queryProfilesWithQueryElements:(NSArray<CMPQueryElements *> *)queryElements completion:(void (^)(CMPResult<NSArray<CMPProfile *> *> *))completion {
    NSString *query = [CMPQueryBuilder buildQueryWithElements:queryElements];
    CMPQueryProfilesTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPQueryProfilesTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID token:token queryString:query];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<NSArray<CMPProfile *> *> * result) {
        completion(result);
    }];
}

@end
