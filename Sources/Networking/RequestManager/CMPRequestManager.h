//
//  CMPRequestManager.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 17/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPRequestTemplate.h"

@class CMPRequestManager;

@protocol CMPRequestManagerDelegate

- (void)requestManagerNeedsToken:(CMPRequestManager *)requestManager;

@end

typedef NS_ENUM(NSInteger, CMPTokenState) {
    CMPTokenStateMissing,
    CMPTokenStateAwaiting,
    CMPTokenStateReady,
    CMPTokenStateFailed
};

typedef void(^CMPPendingOperation)(void);

@interface CMPRequestManager : NSObject

@property (nonatomic, weak, nullable) id<CMPRequestPerforming> requestPerformer;
@property (nonatomic, weak, nullable) id<CMPRequestManagerDelegate> delegate;

- (instancetype)initWithRequestPerformer:(id<CMPRequestPerforming>)requestPerformer;
- (void)performUsingTemplateBuilder:(id<CMPHTTPRequestTemplate>(^)(NSString *))templateBuilder completion:(void(^)(CMPRequestTemplateResult *))completion;
- (void)updateToken:(NSString *)token;
- (void)tokenUpdateFailed;

@end


