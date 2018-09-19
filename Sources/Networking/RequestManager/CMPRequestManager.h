//
//  CMPRequestManager.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 17/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPErrors.h"
#import "CMPRequestTemplate.h"

@class CMPRequestManager;

typedef NS_ENUM(NSInteger, CMPTokenState) {
    CMPTokenStateMissing,
    CMPTokenStateAwaiting,
    CMPTokenStateReady,
    CMPTokenStateFailed
};

typedef void(^CMPPendingOperation)(void);

@protocol CMPRequestManagerDelegate

- (void)requestManagerNeedsToken:(CMPRequestManager *)requestManager;

@end

@interface CMPRequestManager : NSObject

@property (nonatomic, strong) id<CMPRequestPerforming> requestPerformer;
@property (nonatomic, weak, nullable) id<CMPRequestManagerDelegate> delegate;

- (instancetype)initWithRequestPerformer:(id<CMPRequestPerforming>)requestPerformer;
- (void)performUsingTemplateBuilder:(id<CMPHTTPRequestTemplate>(^)(NSString *))templateBuilder completion:(void(^)(CMPRequestTemplateResult *))completion;
- (void)updateToken:(NSString *)token;
- (void)tokenUpdateFailed;

@end


