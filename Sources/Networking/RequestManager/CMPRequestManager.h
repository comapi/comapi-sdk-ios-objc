//
//  CMPRequestManager.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 17/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"

@class CMPRequestManager;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(RequestManagerDelegate)
@protocol CMPRequestManagerDelegate

- (void)requestManagerNeedsToken:(CMPRequestManager *)requestManager;

@end

typedef NS_ENUM(NSInteger, CMPTokenState) {
    CMPTokenStateMissing,
    CMPTokenStateAwaiting,
    CMPTokenStateReady,
    CMPTokenStateFailed
} NS_SWIFT_NAME(TokenState);

typedef void(^CMPPendingOperation)(void) NS_SWIFT_NAME(PendingOperation);

NS_SWIFT_NAME(RequestManager)
@interface CMPRequestManager : NSObject

@property (nonatomic, weak, nullable) id<CMPRequestPerforming> requestPerformer;
@property (nonatomic, weak, nullable) id<CMPRequestManagerDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithRequestPerformer:(id<CMPRequestPerforming>)requestPerformer;
- (void)performUsingTemplateBuilder:(id<CMPHTTPRequestTemplate>(^)(NSString *))templateBuilder completion:(void(^)(CMPResult<id> *))completion;
- (void)updateToken:(NSString *)token;
- (void)tokenUpdateFailed;

@end

NS_ASSUME_NONNULL_END

